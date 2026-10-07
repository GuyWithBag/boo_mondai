# Deck Creation Guide

Use this guide when creating deck folders for the BooMondai deck importer.

Create one folder per deck. For this project, title the decks exactly:

- `Set A Deck`
- `Set B Deck`

The deck title inside `decks.json` should match the folder name.

## Folder Structure

Each deck folder should look like this:

```text
Set A Deck/
  decks.json
  attachments/
    person.webp
    bonjour.mp3
    map.png
```

or:

```text
Set B Deck/
  decks.json
  attachments/
    cafe.webp
    pronunciation.wav
```

When importing, select the deck folder itself, such as `Set A Deck/` or
`Set B Deck/`. Do not select only the `attachments/` folder.

## Attachments

Put all images and audio files inside:

```text
<deckTitle>/attachments/
```

Then reference them in card text by filename only:

```md
![Person](person.webp)
![Bonjour audio](bonjour.mp3)
```

Do not write an absolute path. Do not write `local:`. Do not write
`/attachments/person.webp`.

Good:

```json
"front_text": "bonjour ![Person](person.webp) ![Audio](bonjour.mp3)"
```

Supported audio extensions include `mp3`, `m4a`, `aac`, `wav`, and `ogg`.
## Basic JSON Shape

Every `decks.json` should use this shape:

```json
{
  "type": "Deck",
  "title": "Set A Deck",
  "templates": []
}
```

Change `"title"` to `"Set B Deck"` for the Set B file.

## Updated values

Older sample files, including `context/test_template_imports/validate.json`,
use older field names. For new deck imports, use the updated field names below.

Top-level deck:

| Old value | Updated value |
| --- | --- |
| `"title": "Japanese Set A - Mixed Formats"` | `"title": "Set A Deck"` or `"title": "Set B Deck"` |

Flashcard:

| Old value | Updated value |
| --- | --- |
| `frontText` | `front_text` |
| `backText` | `back_text` |
| `direction` | `direction` stays the same |

Word scramble:

| Old value | Updated value |
| --- | --- |
| `sentenceToScramble` | `sentence_to_scramble` |

Identification:

| Old value | Updated value |
| --- | --- |
| `prompt_text` | `prompt_text` stays the same |
| `answers[].answer` | `answers[].value` |
| `answers[].casing_type` | `answers[].casing_type` stays the same |

Fill in the blanks:

| Old value | Updated value |
| --- | --- |
| `prompt_text` | `prompt_text` stays the same |
| `answer_keys[].value` | `answer_keys[].value` stays the same |
| `answer_keys[].casing_type` | `answer_keys[].casing_type` stays the same |
| missing `answer_keys[].order` | add `answer_keys[].order`, starting at `0` |

Multiple choice:

| Old value | Updated value |
| --- | --- |
| `questionPrompt` | `question_prompt` |
| `options[].optionText` | `options[].option_text` |
| `options[].isCorrect` | `options[].is_correct` |

Matching type:

| Old value | Updated value |
| --- | --- |
| `"type": "match_madness"` | `"type": "matching_type"` |
| `pairs` | `values` |
| `pairs[].term` | create one `values[]` item with `text` |
| `pairs[].match` | create another `values[]` item with `text` |
| missing positions | add `position` and `match_position` for every value |

Old matching example:

```json
{
  "type": "match_madness",
  "pairs": [
    {
      "term": "bonjour",
      "match": "hello"
    }
  ]
}
```

Updated matching example:

```json
{
  "type": "matching_type",
  "values": [
    {
      "text": "bonjour",
      "position": {
        "x": 0,
        "y": 0
      },
      "match_position": {
        "x": 1,
        "y": 0
      }
    },
    {
      "text": "hello",
      "position": {
        "x": 1,
        "y": 0
      },
      "match_position": {
        "x": 0,
        "y": 0
      }
    }
  ]
}
```


## Complete Example

This example includes all supported card template types:

```json
{
  "type": "Deck",
  "title": "Set A Deck",
  "templates": [
    {
      "type": "flashcard",
      "front_text": "bonjour ![Person](person.webp) ![Audio](bonjour.mp3)",
      "back_text": "hello",
      "direction": "normal"
    },
    {
      "type": "word_scramble",
      "sentence_to_scramble": "Je parle francais"
    },
    {
      "type": "identification",
      "prompt_text": "Translate: hello",
      "answers": [
        {
          "value": "bonjour",
          "casing_type": "any"
        }
      ]
    },
    {
      "type": "fill_in_the_blanks",
      "prompt_text": "Je parle ____.",
      "answer_keys": [
        {
          "value": "francais",
          "casing_type": "any",
          "order": 0
        }
      ]
    },
    {
      "type": "multiple_choice",
      "question_prompt": "Which word means hello?",
      "options": [
        {
          "option_text": "bonjour",
          "is_correct": true
        },
        {
          "option_text": "fromage",
          "is_correct": false
        },
        {
          "option_text": "rouge",
          "is_correct": false
        }
      ]
    },
    {
      "type": "matching_type",
      "values": [
        {
          "text": "bonjour",
          "position": {
            "x": 0,
            "y": 0
          },
          "match_position": {
            "x": 1,
            "y": 0
          }
        },
        {
          "text": "hello",
          "position": {
            "x": 1,
            "y": 0
          },
          "match_position": {
            "x": 0,
            "y": 0
          }
        },
        {
          "text": "merci",
          "position": {
            "x": 0,
            "y": 1
          },
          "match_position": {
            "x": 1,
            "y": 1
          }
        },
        {
          "text": "thank you",
          "position": {
            "x": 1,
            "y": 1
          },
          "match_position": {
            "x": 0,
            "y": 1
          }
        }
      ]
    }
  ]
}
```

## Template Types

### Flashcard

Use this for a front side and a back side.

Required fields:

- `type`: must be `"flashcard"`
- `front_text`: the prompt shown first
- `back_text`: the answer shown after flipping

Use this:

- `direction`: `"both"`

Example:

```json
{
  "type": "flashcard",
  "front_text": "bonjour ![Audio](bonjour.mp3)",
  "back_text": "hello",
  "direction": "both"
}
```

### Word Scramble

Use this when the learner must rebuild a sentence from scrambled words.

Required fields:

- `type`: must be `"word_scramble"`
- `sentence_to_scramble`: the full correct sentence

Example:

```json
{
  "type": "word_scramble",
  "sentence_to_scramble": "Je parle francais"
}
```

### Identification

Use this when the learner types an answer.

Required fields:

- `type`: must be `"identification"`
- `prompt_text`: the question or prompt
- `answers`: accepted answers

Each answer needs:

- `value`: the correct answer text
- `casing_type`: usually `"any"`

Example:

```json
{
  "type": "identification",
  "prompt_text": "Translate: hello",
  "answers": [
    {
      "value": "bonjour",
      "casing_type": "any"
    }
  ]
}
```

### Fill In The Blanks

Use this when the learner fills one or more missing words.

Required fields:

- `type`: must be `"fill_in_the_blanks"`
- `prompt_text`: the sentence with blanks
- `answer_keys`: the correct answers

Each answer key needs:

- `value`: the correct text for that blank
- `casing_type`: usually `"any"`
- `order`: starts at `0`; use `1`, `2`, and so on for more blanks

Example:

```json
{
  "type": "fill_in_the_blanks",
  "prompt_text": "Je parle ____.",
  "answer_keys": [
    {
      "value": "francais",
      "casing_type": "any",
      "order": 0
    }
  ]
}
```

### Multiple Choice

Use this when the learner chooses from a list of options.

Required fields:

- `type`: must be `"multiple_choice"`
- `question_prompt`: the question text
- `options`: the choices

Each option needs:

- `option_text`: the visible choice
- `is_correct`: `true` for the correct choice, `false` for wrong choices

Example:

```json
{
  "type": "multiple_choice",
  "question_prompt": "Which word means hello?",
  "options": [
    {
      "option_text": "bonjour",
      "is_correct": true
    },
    {
      "option_text": "fromage",
      "is_correct": false
    },
    {
      "option_text": "rouge",
      "is_correct": false
    }
  ]
}
```

### Matching Type

Use this when the learner matches two related items.

Required fields:

- `type`: must be `"matching_type"`
- `values`: all items shown in the matching activity

Each value needs:

- `text`: the visible text
- `position`: where this item starts
- `match_position`: the position of the item it should match

Think of `position` and `match_position` as coordinates. Matching items point to
each other.

Example:

```json
{
  "type": "matching_type",
  "values": [
    {
      "text": "bonjour",
      "position": {
        "x": 0,
        "y": 0
      },
      "match_position": {
        "x": 1,
        "y": 0
      }
    },
    {
      "text": "hello",
      "position": {
        "x": 1,
        "y": 0
      },
      "match_position": {
        "x": 0,
        "y": 0
      }
    }
  ]
}
```

## Casing Types

For typed answers, use one of these `casing_type` values:

- `any`: capitalization does not matter
- `exact`: answer must match exactly
- `camel`
- `pascal`
- `snake`
- `kebab`
- `title`

Most decks should use `"any"`.

## Final Checklist

Before sending the deck folder:

- The folder is named `Set A Deck` or `Set B Deck`.
- `decks.json` is directly inside the deck folder.
- `attachments/` is directly inside the deck folder.
- Every attachment used in the JSON exists in `attachments/`.
- Attachment links use only filenames, like `person.webp` or `bonjour.mp3`.
- The JSON uses the exact field names shown in this guide.
- The JSON has no trailing commas.
- The deck title inside `decks.json` matches the folder name.
