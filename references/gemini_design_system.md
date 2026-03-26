### **1 & 7. Color Palette (Light & Dark Mode)**

The palette uses a vibrant indigo as the primary brand color to inspire focus, paired with energetic semantic colors for gamification and clear feedback.

| Role | Light Theme (Hex) | Dark Theme (Hex) | Usage Context |
| :--- | :--- | :--- | :--- |
| **Primary** | `#5C6BC0` (Indigo) | `#7986CB` (Soft Indigo) | Main buttons, active tabs, progress bars |
| **On Primary** | `#FFFFFF` | `#000000` | Text/icons on primary surfaces |
| **Secondary** | `#FF7043` (Coral) | `#FF8A65` (Light Coral) | Accent buttons, highlights, new item badges |
| **Tertiary** | `#26A69A` (Teal) | `#4DB6AC` (Soft Teal) | Secondary data points, minor accents |
| **Background** | `#F8F9FA` (Off-White) | `#121212` (Deep Gray) | Base app background |
| **Surface** | `#FFFFFF` (White) | `#1E1E1E` (Elevated Gray)| Cards, bottom sheets, dialogs |
| **Surface Variant** | `#F0F2F5` (Light Gray) | `#2C2C2C` (Mid Gray) | Input fields backgrounds, skeletons |
| **Error** | `#E53935` (Red) | `#EF5350` (Light Red) | Error messages, destructive actions |
| **Text Primary** | `#212121` (Near Black) | `#E0E0E0` (Off-White) | Headlines, body text |
| **Text Secondary**| `#757575` (Mid Gray) | `#9E9E9E` (Light Gray) | Subtitles, captions, disabled text |

#### **Semantic Colors (Gamification & FSRS)**
| Role | Color (Hex) | Dark Theme (Hex) | Usage Context |
| :--- | :--- | :--- | :--- |
| **Correct / Good** | `#4CAF50` (Green) | `#81C784` | Correct answers, FSRS "Good" rating |
| **Incorrect / Again**| `#F44336` (Red) | `#E57373` | Wrong answers, FSRS "Again" rating |
| **Hard** | `#FF9800` (Orange) | `#FFB74D` | FSRS "Hard" rating |
| **Easy** | `#2196F3` (Blue) | `#64B5F6` | FSRS "Easy" rating |
| **Streak Fire** | `#FFC107` (Amber) | `#FFD54F` | Streak counters, flame icons, milestones |

---

### **2. Typography Scale**

**Font Family:** `Noto Sans` (Google Fonts). This ensures excellent legibility for Latin characters while providing native, seamless support for CJK (Chinese, Japanese, Korean) characters, which is crucial for a language learning app.

| Token | Size / Weight | Line Height | Usage |
| :--- | :--- | :--- | :--- |
| **displayLarge** | 48px / Bold (700) | 1.2 | Big streak reveals, major score screens |
| **headlineMedium**| 28px / Bold (700) | 1.3 | Screen titles, bottom sheet headers |
| **titleLarge** | 22px / SemiBold (600)| 1.3 | Card titles, deck names |
| **titleMedium** | 16px / SemiBold (600)| 1.4 | Section headers, list items |
| **bodyLarge** | 16px / Regular (400) | 1.5 | Main reading text, quiz questions |
| **bodyMedium** | 14px / Regular (400) | 1.5 | Secondary text, survey descriptions |
| **labelLarge** | 14px / Medium (500) | 1.0 | Primary buttons, tabs |
| **labelSmall** | 11px / Medium (500) | 1.0 | Badges, overline text, bottom nav labels|

---

### **3. Spacing Scale**

Based on a strict 4px grid to maintain visual rhythm.

* **xs (4px):** Micro-adjustments, spacing between an icon and its text label.
* **sm (8px):** Spacing between tightly grouped elements (e.g., list tile title and subtitle).
* **md (16px):** Default padding for cards, standard screen margins.
* **lg (24px):** Spacing between distinct vertical sections.
* **xl (32px):** Padding for bottom sheets, large bottom margins before buttons.
* **xxl (48px):** Spacing between massive UI components or empty state illustrations.

---

### **4. Component Styles**

To balance "playful" and "clear," we use rounded corners, slight borders on surfaces, and crisp shadows.

* **Cards (Decks, Quiz, Leaderboard)**
    * *Border Radius:* `16px`
    * *Background:* Surface color (`#FFFFFF` or `#1E1E1E`)
    * *Border:* `1px` solid `Surface Variant` (adds Notion-like crispness)
    * *Elevation/Shadow:* `Y: 2`, `Blur: 8`, `Color: #000000` at `5%` opacity. (No shadow in dark mode).
* **Buttons**
    * *Border Radius:* `12px` (Slightly less round than cards to look clickable).
    * *Primary Filled:* Background Primary (`#5C6BC0`), Elevation 0. Hover/Pressed: Scale down to 0.98.
    * *Secondary Outlined:* Background Transparent, Border `2px` solid `Surface Variant`, Text `Text Primary`.
    * *Rating Buttons (FSRS):* Filled with their respective semantic colors at 15% opacity, with text/icon in the full semantic color. Border `1px` solid semantic color.
* **Input Fields (Text & Likert)**
    * *Border Radius:* `12px`
    * *Background:* `Surface Variant` (Light gray)
    * *Border:* None by default. Focused state: `2px` solid `Primary`.
    * *Likert Scale:* Radio buttons using `Primary` color when selected, housed in a horizontal row with `md` (16px) spacing.
* **Navigation**
    * *Bottom Nav Bar:* Surface color, no elevation, top border `1px` solid `Surface Variant`.
    * *Active Icon:* `Primary` color, slightly scaled up (1.1x).
    * *Top App Bar:* Transparent background, elevation 0, `Text Primary` for icons/text.
* **Badges (Streak, Rank)**
    * *Border Radius:* `100px` (Pill shape)
    * *Padding:* `sm` vertical, `md` horizontal.
    * *Streak Flame:* Background `Streak Fire` at 15% opacity, text/icon full `Streak Fire` color.
* **Bottom Sheets**
    * *Border Radius:* Top left/right `24px`.
    * *Drag Handle:* `4px` high, `32px` wide, `Surface Variant` color, rounded corners.
* **Skeleton Loading**
    * *Color:* `Surface Variant`
    * *Animation:* Shimmer effect (moving gradient from `Surface Variant` to slightly lighter/darker variant).
    * *Border Radius:* Matches the component it is replacing.

---

### **5. Key Screen Layouts (Wireframes)**

* **Home Dashboard**
    * *Top Bar:* User avatar (left), Streak Badge (right).
    * *Hero Section:* Large "Due Reviews" card (Primary color background, white text) with a bold "Start Session" button.
    * *Section Header:* "Recent Activity" (`titleMedium`).
    * *List:* Horizontal scrolling row of recently accessed Deck Cards.
* **Deck List**
    * *Layout:* 2-column Grid view with `md` (16px) spacing.
    * *Deck Card Items:* Deck title (`titleLarge`), subtext with card count (`bodyMedium`), and a small circular progress indicator in the bottom right.
* **Quiz Session**
    * *Top Bar:* Close button (left), Progress Bar spanning the center width (filled with Primary color).
    * *Center:* Large Question Card (elevated, white background) displaying the target word/sentence (`displayLarge`).
    * *Bottom:* Input field or multiple-choice buttons. Primary "Check" button anchored to the bottom padding.
* **FSRS Review**
    * *Center:* Flashcard taking up 60% of screen height. Tapping anywhere flips it.
    * *Bottom (Post-Flip):* 4 equal-width rating buttons (Again, Hard, Good, Easy) aligned horizontally.
* **Leaderboard**
    * *Top Header:* Top 3 podium graphic (1st, 2nd, 3rd place avatars).
    * *List:* Scrollable vertical list. Each row contains: Rank number, Avatar, Username (`titleMedium`), and Score Badge (`Streak Fire` color).
    * *Sticky Bottom:* The current user's rank pinned to the bottom of the screen.
* **Survey Page**
    * *Header:* Survey title and progress indicator.
    * *Body:* Scrollable list. Each item is a Card containing a question (`bodyLarge`) and a 5-point Likert scale (custom radio group with emojis or numbers).

---

### **6. Animation Guidelines**

Smooth, snappy animations are key to the "Duolingo/Notion" blend. Use standard Flutter physics (Spring simulation) where possible.

* **Card Flip (FSRS):** `400ms` duration. Custom `Curve.easeInOutCubic`. Must rotate on the Y-axis.
* **Page Transitions:** `300ms` duration. Fade-through or subtle slide-up (bottom-to-top) to feel lightweight and web-like (Notion style).
* **Score/Streak Reveal:** `600ms` duration. Use a spring animation. The number should "count up" (e.g., 0 to 150) rather than appearing instantly. Add a slight scale-up bounce (`1.2x` down to `1.0x`) when it hits the final number.
* **Button Presses:** `100ms` scale down to `0.95`, `100ms` scale back to `1.0` on release. Immediate visual feedback.
* **Incorrect Answer (Shake):** `400ms`. 3 quick horizontal translation shakes (left/right by `4px`) and a brief flash of the `Error` color border.

> **Developer Note:** Map these specific durations to your Flutter `AnimationController` standard durations to keep the app feeling cohesive across all interactive elements.

---
