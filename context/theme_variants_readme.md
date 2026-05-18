# theme_variants

A Flutter package for building customizable themes and typed, CVA-inspired style variants.

`theme_variants` helps apps register multiple named themes, choose separate themes for light and dark mode, expose typed design tokens, and resolve reusable component styles from typed variant values.

## Features

- Register named themes with `ThemeData` and custom typed tokens.
- Support themes with separate light/dark variants.
- Support themes that use the same style in both light and dark mode.
- Select light and dark themes independently.
- Use a Flutter-integrated `ChangeNotifier` controller and inherited provider.
- Build CVA-like typed style recipes for Flutter objects such as `TextStyle` and `ButtonStyle`.
- Define default variants and compound variants.

## Core Concepts

### Theme Variants

A `ThemeVariant<TTokens>` combines Flutter `ThemeData` with your own token type.
For small token sets, a Dart record typedef keeps the code light:

```dart
typedef AppTokens = ({
  String name,
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

Tokens are similar to CSS variables, but typed in Dart:

```dart
final cleanLight = ThemeVariant<AppTokens>(
  id: 'clean-light',
  themeData: ThemeData.light(useMaterial3: true),
  tokens: (
    name: 'Clean Light',
    primary: Colors.blue,
    onPrimary: Colors.white,
    danger: Colors.red,
    onDanger: Colors.white,
    radius: 8,
    borderWidth: 1,
    spaceSm: 8,
    spaceMd: 12,
    spaceLg: 18,
  ),
);
```

For larger design systems, a regular class works too.

### Tailwind and CVA Mental Model

`AppTokens` does not map directly to CVA. It is closer to Tailwind theme config or CSS custom properties.

```js
// tailwind.config.js
theme: {
  extend: {
    colors: {
      primary: '#3b82f6',
    },
    borderRadius: {
      DEFAULT: '8px',
    },
  },
}
```

The same idea in this package is:

```dart
typedef AppTokens = ({
  String name,
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

Think of the pieces this way:

| Tailwind/CVA concept | `theme_variants` concept |
| --- | --- |
| Tailwind theme values or CSS variables | `AppTokens` |
| `cva(...)` recipe | `VariantStyle<TTokens, TValue>` |
| `variants.size` | typed enum such as `ButtonSize` |
| `variants.tone` | typed enum such as `ButtonTone` |
| `defaultVariants` | `defaultVariants` |
| `compoundVariants` | `CompoundVariant` |
| returned class string | resolved Flutter style object |

In short, tokens provide theme values, and variants decide which style pieces to apply.

### Theme Registry

Use `LightDarkThemeVariant` when a theme has separate light and dark values.
Use `SingleThemeVariant` when one theme should be used for both modes.

```dart
final registry = ThemeVariantRegistry<AppTokens>(
  themes: {
    'clean': LightDarkThemeVariant(
      light: cleanLight,
      dark: cleanDark,
    ),
    'mono': SingleThemeVariant(monoTheme),
  },
);
```

### Theme Controller

`ThemeVariantsController` tracks the selected light theme, selected dark theme, and `ThemeMode`.

```dart
final controller = ThemeVariantsController<AppTokens>(
  registry: registry,
  lightThemeId: 'clean',
  darkThemeId: 'mono',
);

controller.setLightTheme('clean');
controller.setDarkTheme('mono');
controller.setThemeMode(ThemeMode.system);
```

### User Overrides

Use `transform` when an app lets users customize a preset theme. Registered
themes stay immutable; the transform applies user settings to the resolved
theme.

```dart
final controller = ThemeVariantsController<AppTokens>(
  registry: registry,
  lightThemeId: 'clean',
  darkThemeId: 'mono',
  transform: (theme) {
    final primary = userSettings.primary ?? theme.tokens.primary;

    return ThemeVariant(
      id: theme.id,
      themeData: theme.themeData.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: theme.themeData.brightness,
        ),
        fontFamily: userSettings.fontFamily,
      ),
      tokens: (
        name: theme.tokens.name,
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

If users can edit many token fields, prefer a token class with `copyWith` in
your app instead of a record typedef.

## Usage

Wrap your app with `ThemeVariantsProvider`, then connect the selected themes to `MaterialApp`.

```dart
ThemeVariantsProvider<AppTokens>(
  controller: controller,
  child: AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      return MaterialApp(
        theme: controller.lightTheme().themeData,
        darkTheme: controller.darkTheme().themeData,
        themeMode: controller.themeMode,
        home: const HomePage(),
      );
    },
  ),
);
```

Inside widgets, read the controller or active tokens from context:

```dart
final controller = context.themeVariantsController<AppTokens>();
final tokens = context.themeTokens<AppTokens>();
```

### Nested Theme Overrides

Subtrees can use their own selected theme while the rest of the app keeps the
root theme. This is useful for previews, flashcards, embedded editors, or
theme-customizable cards.

```dart
ThemeVariantsOverride<AppTokens>(
  lightThemeId: 'forest',
  darkThemeId: 'mono',
  themeMode: ThemeMode.light,
  child: const Flashcard(),
)
```

Omit `themeMode` to inherit the parent light/dark mode. Pass `ThemeMode.light`
or `ThemeMode.dark` when the subtree should keep its own brightness.

Inside `Flashcard`, `context.themeTokens<AppTokens>()` reads the override
theme because it is the nearest provider.

If the card should use the parent theme, disable the override:

```dart
ThemeVariantsOverride<AppTokens>(
  enabled: false,
  lightThemeId: 'forest',
  darkThemeId: 'mono',
  child: const Flashcard(),
)
```

When `enabled` is false, the widget returns `child` directly and the subtree
inherits the parent `ThemeVariantsProvider`.

## Typed Variants

`VariantStyle` is inspired by CVA. Instead of returning CSS classes, it returns a Flutter style object.

The package includes shortcut constructors for common Flutter style types:

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
      foregroundColor: const WidgetStatePropertyAll(Colors.white),
    ),
    ButtonTone.danger: (_) => const ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.red),
      foregroundColor: WidgetStatePropertyAll(Colors.white),
    ),
  },
);
```

Resolve the style with typed variant values:

```dart
FilledButton(
  style: buttonStyle.resolve(tokens, const [
    ButtonSize.lg,
    ButtonTone.danger,
  ]),
  onPressed: () {},
  child: const Text('Delete'),
);
```

Explicit variants replace defaults from the same enum/type group. For example, `ButtonTone.danger` replaces the default `ButtonTone.primary`.

For card surfaces and panels, use `VariantStyle.decoration`:

```dart
final cardDecoration = VariantStyle.decoration<AppTokens>(
  base: (tokens) => BoxDecoration(
    borderRadius: BorderRadius.circular(tokens.radius),
  ),
  variants: {
    CardTone.highlighted: (tokens) => BoxDecoration(
      color: tokens.primary.withValues(alpha: 0.08),
      border: Border.all(color: tokens.primary),
    ),
  },
);
```

## Compound Variants

Use `CompoundVariant` when a style should apply only when multiple variants are selected.

```dart
compoundVariants: [
  CompoundVariant<AppTokens, TextStyle>(
    when: const {ButtonSize.lg, ButtonTone.danger},
    build: (_) => const TextStyle(fontWeight: FontWeight.w700),
  ),
],
```

## Tokens vs Variants vs Layout

Keep theme values, style decisions, and widget behavior separate.

Use **tokens** for theme-specific values:

```text
colors, foreground colors, spacing, radius, border width, typography scales
```

Use **variants** for visual style choices within a component:

```text
size: sm / md / lg
tone: primary / danger / neutral
state: idle / selected / correct / wrong
density: compact / comfortable
```

Use **widget props** for behavior and layout:

```text
row / column / wrap / grid
answer count
shuffle choices
show A/B/C/D labels
disable choices after answering
```

For example, an FSRS multiple-choice widget should usually receive layout as
a prop:

```dart
MultipleChoiceButtons(
  layout: ChoiceLayout.grid,
  choices: choices,
)
```

Then use `VariantStyle` for the style of each answer button, not for deciding
whether the answers render in a row, column, wrap, or grid.

## Example App

This repository includes a runnable example in `example/`.

```bash
cd example
flutter run
```

The example is split by domain:

- `example/lib/theme/`: theme definitions and registry.
- `example/lib/tokens/`: app token model.
- `example/lib/variants/`: typed button style variants.
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

This package is early-stage. The API is intentionally small and focused on theme selection, typed tokens, and CVA-style variant helpers.
