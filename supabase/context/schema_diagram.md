Here are the Entity-Relationship (ER) diagrams for each major system in your V2 database schema. I have broken them down logically so you can visualize how the tables connect within their specific domains.

You can paste these directly into the [Mermaid Live Editor](https://mermaid.live/) or view them natively in markdown viewers that support Mermaid (like GitHub or Notion).

### 1. Core Profiles & Tags Dictionary

This system handles user identities and the global tagging dictionary.

```mermaid
erDiagram
    auth_users {
        uuid id PK
    }
    
    profiles {
        uuid id PK
        uuid user_id FK
        text username
        text role
        bool is_anonymous
    }
    
    tags {
        uuid id PK
        uuid user_id FK
        text name
    }

    auth_users ||--|| profiles : "has"
    profiles ||--o{ tags : "creates"

```

---

### 2. Decks & The Storefront (Listings)

This illustrates the "Git-lite" structure (Decks sourcing from other Decks) and the separation of curriculum data from storefront marketing data.

```mermaid
erDiagram
    profiles {
        uuid id PK
    }

    decks {
        uuid id PK
        uuid user_id FK
        text title
        uuid source_deck_id FK "For Forking"
        visibility_state visibility_state
        jsonb design_config
    }

    deck_listings {
        uuid deck_id PK, FK
        int upvotes_count
        int downloads_count
        jsonb featured_cards
        text[] featured_images
    }

    deck_tags {
        uuid deck_id PK, FK
        uuid tag_id PK, FK
    }

    tags {
        uuid id PK
    }

    profiles ||--o{ decks : "owns"
    decks ||--o{ decks : "forks from (source_deck_id)"
    decks ||--|| deck_listings : "has storefront metadata"
    decks ||--o{ deck_tags : "has"
    tags ||--o{ deck_tags : "tags"

```

---

### 3. Card Templates & Question Types

This shows how the core `card_templates` table acts as a parent for specific question-type data, allowing polymorphic relationships.

```mermaid
erDiagram
    decks {
        uuid id PK
    }

    card_templates {
        uuid id PK
        uuid deck_id FK
        text type
        uuid source_template_id FK "For Forking"
        jsonb design_config
    }

    multiple_choice_options {
        uuid id PK
        uuid template_id FK
        text option_text
        bool is_correct
    }

    fill_in_the_blank_segments {
        uuid id PK
        uuid card_id FK
        text full_text
        text correct_answer
    }

    match_madness_pairs {
        uuid id PK
        uuid template_id FK
        text term
        text match
    }

    card_template_tags {
        uuid template_id PK, FK
        uuid tag_id PK, FK
    }

    decks ||--o{ card_templates : "contains"
    card_templates ||--o{ card_templates : "forks from (source)"
    card_templates ||--o{ multiple_choice_options : "has options (if MCQ)"
    card_templates ||--o{ fill_in_the_blank_segments : "has segments (if FITB)"
    card_templates ||--o{ match_madness_pairs : "has pairs (if Match)"
    card_templates ||--o{ card_template_tags : "has"

```

---

### 4. Local Study Data, Sessions & FSRS Engine

This is the most complex system. It tracks what the user is studying locally, their session drill states, and the FSRS algorithm states.

```mermaid
erDiagram
    profiles ||--|| streaks : "maintains"
    profiles ||--o{ drill_sessions : "starts"
    profiles ||--o{ review_sessions : "starts"
    
    decks ||--o{ review_cards : "groups"
    card_templates ||--o{ review_cards : "generates"
    
    review_cards {
        uuid id PK
        uuid template_id FK
        uuid deck_id FK
        bool is_reversed
    }

    user_review_card_tags {
        uuid user_id PK, FK
        uuid review_card_id PK, FK
        uuid tag_id PK, FK
    }

    fsrs_cards {
        uuid id PK
        uuid user_id FK
        uuid review_card_id FK
        jsonb state
    }

    review_logs {
        uuid id PK
        uuid fsrs_card_id FK
        jsonb log
    }

    drill_sessions {
        uuid id PK
        uuid user_id FK
        uuid deck_id FK
        int correct_count
    }

    drill_answers {
        uuid id PK
        uuid session_id FK
        uuid card_id FK
        text user_answer
        study_rating type
    }

    profiles ||--o{ user_review_card_tags : "adds personal tags"
    review_cards ||--o{ user_review_card_tags : "has personal tags"
    
    review_cards ||--|| fsrs_cards : "tracks algorithm state"
    fsrs_cards ||--o{ review_logs : "creates history"
    
    drill_sessions ||--o{ drill_answers : "records"
    card_templates ||--o{ drill_answers : "answered"

```

---

### 5. Tracking & Social Engagement

This maps the interactions users have with the public storefront. Note how they all point back to the parent `decks` table, which triggers updates to `deck_listings`.

```mermaid
erDiagram
    decks {
        uuid id PK
    }

    profiles {
        uuid id PK
    }

    deck_votes {
        uuid deck_id PK, FK
        uuid user_id PK, FK
        int vote_value
    }

    deck_downloads {
        uuid deck_id PK, FK
        uuid user_id PK, FK
    }

    deck_favorites {
        uuid deck_id PK, FK
        uuid user_id PK, FK
    }

    deck_reports {
        uuid id PK
        uuid deck_id FK
        uuid user_id FK
        text reason
        text status
    }

    profiles ||--o{ deck_votes : "casts"
    decks ||--o{ deck_votes : "receives"

    profiles ||--o{ deck_downloads : "downloads"
    decks ||--o{ deck_downloads : "receives"

    profiles ||--o{ deck_favorites : "favorites"
    decks ||--o{ deck_favorites : "receives"

    profiles ||--o{ deck_reports : "files"
    decks ||--o{ deck_reports : "receives"

```

---

### 6. Research & Analytics

The isolated tables meant for your A/B testing, demographics, and survey data collection.

```mermaid
erDiagram
    profiles {
        uuid id PK
    }

    research_profiles {
        uuid id PK
        uuid user_id FK
        text role
        text goal
    }

    research_codes {
        uuid id PK
        text code
        uuid created_by FK
        uuid used_by FK
    }

    survey_responses {
        uuid id PK
        uuid user_id FK
        text survey_type
        jsonb responses
    }

    vocabulary_test_results {
        uuid id PK
        uuid user_id FK
        text test_set
        int score
    }

    profiles ||--|| research_profiles : "extends (if participant)"
    profiles ||--o{ research_codes : "creates / claims"
    profiles ||--o{ survey_responses : "submits"
    profiles ||--o{ vocabulary_test_results : "takes"

```
