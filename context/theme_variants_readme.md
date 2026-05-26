# theme_variants

A manager for multiple custom Flutter themes, modeled after Tailwind CSS v4
theme tokens and CVA, but written in a Dart-first style.

`theme_variants` gives you:

- A registry of named theme presets.
- Separate light and dark theme selection.
- Typed design tokens for your app.
- CVA-style typed component variants that resolve to Flutter style objects.
- Optional import/export hooks for persistence.

It does not persist data for you. It gives you a model that can be serialized
cleanly, while your app chooses the database, file format, DTOs, and codecs.

## Tailwind v4 Theme Tokens

Tailwind CSS v4 lets you define design tokens in CSS:

```css
@theme {
  --color-primary: #3b82f6;
  --color-danger: #ef4444;
  --radius-card: 8px;
  --spacing-sm: 8px;
  --spacing-md: 12px;
  --spacing-lg: 18px;
}
```

In `theme_variants`, the same idea is a typed Dart token model:

```dart
typedef AppTokens = ({
  Color primary,
  Color onPrimary,
  Color danger,
  Color onDanger,
  double radius,
  double borderWidth,
  double spaceSm,
  double spaceMd,
  double spaceLg,
});
```

Tokens are theme values. They should be boring, reusable data: colors, spacing,
radii, borders, and typography scales.

They are not the component variant system. They are the values that component
variants read from.

## CVA-Style Variants

CVA decides which style fragments apply:

```ts
const button = cva("rounded", {
  variants: {
    size: {
      sm: "px-3 py-2",
      lg: "px-6 py-4",
    },
    tone: {
      primary: "bg-primary text-white",
      danger: "bg-danger text-white",
    },
  },
  defaultVariants: {
    size: "md",
    tone: "primary",
  },
});
```

In Dart, use enums for variant axes and `VariantStyle` for the recipe:

```dart
enum ButtonSize { sm, md, lg }
enum ButtonTone { primary, danger }

final buttonStyle = VariantStyle.button<AppTokens>(
  base: (tokens) => ButtonStyle(
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radius),
      ),
    ),
  ),
  defaultVariants: const [ButtonSize.md, ButtonTone.primary],
  variants: {
    ButtonSize.sm: (_) => const ButtonStyle(
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    ),
    ButtonSize.lg: (_) => const ButtonStyle(
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    ButtonTone.primary: (tokens) => ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(tokens.primary),
      foregroundColor: WidgetStatePropertyAll(tokens.onPrimary),
    ),
    ButtonTone.danger: (tokens) => ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(tokens.danger),
      foregroundColor: WidgetStatePropertyAll(tokens.onDanger),
    ),
  },
);
```

Or you can use parts for a cleaner syntax:

```dart
final buttonStyle = VariantStyle.buttonParts<AppTokens>(
  base: (tokens) => {
    ButtonStylePart.shape(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radius),
      ),
    ),
  },
  defaultVariants: const [ButtonSize.md, ButtonTone.primary],
  variants: {
    ButtonSize.sm: (_) => {
      ButtonStylePart.padding(
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    },
    ButtonSize.lg: (_) => {
      ButtonStylePart.padding(
        const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    },
    ButtonTone.primary: (tokens) => {
      ButtonStylePart.backgroundColor(tokens.primary),
      ButtonStylePart.foregroundColor(tokens.onPrimary),
    },
    ButtonTone.danger: (tokens) => {
      ButtonStylePart.backgroundColor(tokens.danger),
      ButtonStylePart.foregroundColor(tokens.onDanger),
    },
  },
);
```

Resolve it inside a widget:

```dart
final tokens = context.themeTokens<AppTokens>();

FilledButton(
  style: buttonStyle.resolve(tokens, const [
    ButtonSize.lg,
    ButtonTone.danger,
  ]),
  onPressed: () {},
  child: const Text('Delete'),
);
```

The mapping is:

| Tailwind/CVA | `theme_variants` |
| --- | --- |
| Tailwind v4 `@theme` variables | `AppTokens` |
| `cva(...)` recipe | `VariantStyle<TTokens, TValue>` |
| `variants.size` | enum such as `ButtonSize` |
| `variants.tone` | enum such as `ButtonTone` |
| `defaultVariants` | `defaultVariants` |
| `compoundVariants` | `CompoundVariant` |
| class string output | Flutter style object |

## Recommended Setup

### 1. Define Tokens

Use records for small projects:

```dart
typedef AppTokens = ({
  Color primary,
  Color onPrimary,
  Color danger,
  Color onDanger,
  double radius,
  double borderWidth,
  double spaceSm,
  double spaceMd,
  double spaceLg,
});
```

Use a class with `copyWith` for larger apps or user-editable themes.

### 2. Define Theme Variants

A `ThemeVariant<TTokens>` is the concrete theme payload for one preset slot:

```dart
const cleanLightTokens = (
  primary: Colors.blue,
  onPrimary: Colors.white,
  danger: Colors.red,
  onDanger: Colors.white,
  radius: 8.0,
  borderWidth: 1.0,
  spaceSm: 8.0,
  spaceMd: 12.0,
  spaceLg: 18.0,
);

final cleanLight = ThemeVariant<AppTokens>(
  themePresetId: 'clean',
  brightness: ThemeVariantBrightness.light,
  themeData: ThemeData(
    brightness: Brightness.light,
    colorSchemeSeed: Colors.blue,
    useMaterial3: true,
  ),
  tokens: cleanLightTokens,
);
```

For persistence-friendly modeling, identity lives at the preset level. A variant
uses `themePresetId` plus `brightness` as its natural key.

### 3. Define Presets

Use `LightDarkThemePreset` when a theme has separate light and dark variants:

```dart
final cleanPreset = LightDarkThemePreset<AppTokens>(
  id: 'clean',
  name: 'Clean',
  light: cleanLight,
  dark: cleanDark,
);
```

Use `SingleThemePreset` when one theme should resolve for both light and dark:

```dart
final monoPreset = SingleThemePreset<AppTokens>(
  id: 'mono',
  name: 'Mono',
  theme: monoTheme,
);
```

The preset is the user-facing theme concept. It owns:

- `id`: stable identifier, good for persistence.
- `name`: mutable display name.
- `presetType`: `single` or `lightDark`.

### 4. Register Presets

```dart
final registry = ThemeVariantRegistry<AppTokens>(
  presets: [
    cleanPreset,
    forestPreset,
    monoPreset,
  ],
);
```

The registry indexes presets by `preset.id`.

Useful registry methods:

```dart
registry.getThemes();
registry.getLightThemes();
registry.getDarkThemes();
registry.getSingleThemes();
registry.getPreset('clean');
registry.resolve(id: 'clean', brightness: Brightness.light);
```

### 5. Create a Controller

```dart
final controller = ThemeVariantsController<AppTokens>(
  registry: registry,
  lightThemeId: 'clean',
  darkThemeId: 'forest',
  themeMode: ThemeMode.system,
);
```

Change selections:

```dart
controller.setLightTheme('mono');
controller.setDarkTheme('clean');
controller.setThemeMode(ThemeMode.dark);
```

Read current themes:

```dart
final light = controller.getCurrentLightTheme();
final dark = controller.getCurrentDarkTheme();
final active = controller.getCurrentTheme(platformBrightness);

final activePreset = controller.getCurrentThemePreset(platformBrightness);
```

### 6. Connect to Flutter

```dart
ThemeVariantsProvider<AppTokens>(
  controller: controller,
  child: AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      return MaterialApp(
        theme: controller.getCurrentLightTheme().themeData,
        darkTheme: controller.getCurrentDarkTheme().themeData,
        themeMode: controller.themeMode,
        home: const HomePage(),
      );
    },
  ),
);
```

Inside widgets:

```dart
final controller = context.themeVariantsController<AppTokens>();
final tokens = context.themeTokens<AppTokens>();
final activeVariant = context.activeThemeVariant<AppTokens>();
final activePreset = context.activeThemePreset<AppTokens>();
```

## Nested Theme Overrides

Use `ThemeVariantsOverride` when a subtree should use a different preset.

```dart
ThemeVariantsOverride<AppTokens>(
  lightThemeId: 'forest',
  darkThemeId: 'forest',
  themeMode: ThemeMode.light,
  child: const FlashcardPreview(),
);
```

Omit `themeMode` to inherit the parent light/dark mode. Set `enabled: false`
when the subtree should fall back to the parent provider.

## User Customization

Use `transform` when users customize a resolved preset without mutating the
registered presets.

```dart
final controller = ThemeVariantsController<AppTokens>(
  registry: registry,
  lightThemeId: 'clean',
  darkThemeId: 'forest',
  transform: (theme) {
    final primary = userSettings.primary ?? theme.tokens.primary;

    return ThemeVariant<AppTokens>(
      themePresetId: theme.themePresetId,
      brightness: theme.brightness,
      themeData: theme.themeData.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: theme.themeData.brightness,
        ),
      ),
      tokens: (
        primary: primary,
        onPrimary: theme.tokens.onPrimary,
        danger: theme.tokens.danger,
        onDanger: theme.tokens.onDanger,
        radius: theme.tokens.radius,
        borderWidth: theme.tokens.borderWidth,
        spaceSm: theme.tokens.spaceSm,
        spaceMd: theme.tokens.spaceMd,
        spaceLg: theme.tokens.spaceLg,
      ),
    );
  },
);
```

For heavier customization, prefer a token class with `copyWith`.

## Theme Persistence

The package can export/import maps, but your app decides how `ThemeData` and
tokens become JSON. This is intentional because `ThemeData` is large and not
normally serialized directly.

Export only the theme catalog:

```dart
final exportedThemes = controller.exportThemes(
  encodeThemeData: (themeData) => {
    'brightness': themeData.brightness.name,
    'seed_color': themeData.colorScheme.primary.value,
    'use_material3': themeData.useMaterial3,
  },
  encodeTokens: (tokens) => {
    'primary': tokens.primary.value,
    'on_primary': tokens.onPrimary.value,
    'danger': tokens.danger.value,
    'on_danger': tokens.onDanger.value,
    'radius': tokens.radius,
    'border_width': tokens.borderWidth,
    'space_sm': tokens.spaceSm,
    'space_md': tokens.spaceMd,
    'space_lg': tokens.spaceLg,
  },
);
```

Import theme catalog data:

```dart
controller.importThemes(
  exportedThemes,
  decodeThemeData: (raw) {
    final map = Map<String, Object?>.from(raw as Map);
    final brightness = switch (map['brightness']) {
      'dark' => Brightness.dark,
      _ => Brightness.light,
    };

    return ThemeData(
      brightness: brightness,
      colorSchemeSeed: Color((map['seed_color'] as num).toInt()),
      useMaterial3: (map['use_material3'] as bool?) ?? true,
    );
  },
  decodeTokens: (raw) {
    final map = Map<String, Object?>.from(raw as Map);

    return (
      primary: Color((map['primary'] as num).toInt()),
      onPrimary: Color((map['on_primary'] as num).toInt()),
      danger: Color((map['danger'] as num).toInt()),
      onDanger: Color((map['on_danger'] as num).toInt()),
      radius: (map['radius'] as num).toDouble(),
      borderWidth: (map['border_width'] as num).toDouble(),
      spaceSm: (map['space_sm'] as num).toDouble(),
      spaceMd: (map['space_md'] as num).toDouble(),
      spaceLg: (map['space_lg'] as num).toDouble(),
    );
  },
  mode: ThemeImportMode.replaceAndAdd,
);
```

Import modes:

| Mode | Behavior |
| --- | --- |
| `ThemeImportMode.addOnly` | Add new preset IDs only. Existing IDs stay unchanged. |
| `ThemeImportMode.replaceAndAdd` | Replace matching IDs and add new IDs. |
| `ThemeImportMode.replaceOnly` | Replace the entire registry with imported presets. |

Export full controller state:

```dart
final controllerState = controller.toMap(
  encodeThemeData: encodeThemeData,
  encodeTokens: encodeTokens,
);
```

Import full controller state:

```dart
controller.fromMap(
  controllerState,
  decodeThemeData: decodeThemeData,
  decodeTokens: decodeTokens,
);
```

Full controller state includes:

- `light_theme_id`
- `dark_theme_id`
- `theme_mode`
- `presets`

## CRUD

Controller-level helpers mutate the controller registry and notify listeners:

```dart
controller.addTheme(preset);
controller.addThemes([presetA, presetB]);
controller.removeTheme('clean');
controller.removeThemes(['clean', 'forest']);
controller.clearThemes();
```

Registry-level helpers return a new immutable registry:

```dart
final next = registry
    .addTheme(preset)
    .removeTheme('old-theme');
```

## Style Shortcuts

`VariantStyle` includes shortcuts for common Flutter style objects:

```dart
VariantStyle.button<AppTokens>(...)
VariantStyle.text<AppTokens>(...)
VariantStyle.textTheme<AppTokens>(...)
VariantStyle.icon<AppTokens>(...)
VariantStyle.inputDecoration<AppTokens>(...)
VariantStyle.listTile<AppTokens>(...)
VariantStyle.card<AppTokens>(...)
VariantStyle.chip<AppTokens>(...)
VariantStyle.navigationBar<AppTokens>(...)
VariantStyle.tabBar<AppTokens>(...)
VariantStyle.decoration<AppTokens>(...)
```

Each shortcut also has a `...Parts` constructor when you prefer composable style
fragments:

```dart
final cardDecoration = VariantStyle.decorationParts<AppTokens>(
  base: (tokens) => {
    DecorationPart.radius(tokens.radius),
    DecorationPart.color(Colors.white),
  },
  variants: {
    CardTone.highlighted: (tokens) => {
      DecorationPart.color(tokens.primary.withValues(alpha: 0.08)),
      DecorationPart.border(Border.all(color: tokens.primary)),
    },
  },
);
```

## Compound Variants

Use `CompoundVariant` when a style should apply only when multiple variant
values are selected.

```dart
compoundVariants: [
  CompoundVariant<AppTokens, TextStyle>(
    when: const {ButtonSize.lg, ButtonTone.danger},
    build: (_) => const TextStyle(fontWeight: FontWeight.w700),
  ),
],
```

With `...Parts` constructors, use `CompoundVariantParts`:

```dart
compoundVariants: [
  CompoundVariantParts<AppTokens, TextStyle>(
    when: const {ButtonSize.lg, ButtonTone.danger},
    build: (_) => {
      TextStylePart.fontWeight(FontWeight.w700),
    },
  ),
],
```

## Rules of Thumb

Keep these concerns separate:

| Concern | Use |
| --- | --- |
| Theme values | tokens |
| Component visual choices | `VariantStyle` variants |
| App behavior and layout | widget props |

Use one enum per visual axis:

```dart
enum ButtonSize { sm, md, lg }
enum ButtonTone { primary, danger }
```

Do not pass two values from the same enum/type group:

```dart
// Throws: both values are ButtonSize variants.
buttonStyle.resolve(tokens, const [ButtonSize.sm, ButtonSize.lg]);
```

`resolve` is strict: defaults, selected variants, and compound variants must all
be registered in `variants`.

## Example App

This repository includes a runnable example in `example/`.

```bash
cd example
flutter run
```

The example is split by domain:

- `example/lib/theme/`: theme definitions and registry.
- `example/lib/tokens/`: app token model.
- `example/lib/variants/`: typed style variants.
- `example/lib/screens/`: UI using the package.

## Development

Run package checks from the repository root:

```bash
dart format lib test example/lib example/test
dart analyze
flutter test
```

Run example checks:

```bash
cd example
dart analyze
flutter test
```

## Status

This package is early-stage. The API is focused on theme preset management,
typed tokens, optional persistence hooks, and CVA-style Flutter style recipes.
