Massive Quiz Overhaul because I never tested it:

  So for JLPT N5 Vocabulary, for Tori, it doesnt work recognize that my answer is correct like とり.

  Also when you get the card wrong a total of 3 times, it should just continue in the review section

  It takes too long after I press the self rating part of the cards, is it because it waits for the supabase CRUD? it shouldn't do that. It should only update the deck AFTER the user is done with the
  quiz session.

  SO its also clear there should be a sync system, so make me a sequence diagram for that. Ask me questions for clarifications first.

  Please do a more detailed explanation of the deck/card and review system in @references/class_diagram.md . Make comments.

  /my-decks shouldnt be fetched everytime (use local data first of course), you should add a refresh button so that it fetches manually. It should only fetch automatically if you copied a deck from the
  browser.

  @lib/pages/deck_editor_page.dart should do local first.

  Syncing to supabase should only happen AFTER pressing the sync button that I newly introduced.

  I dont think the review page works, when I finish a quiz with good, it should appear on review with the fsrs indicator of when it will appear (10 mins or something, depends on the fsrs) (you can also
  take this ahead of time and you dont have to actually wait 10 mins)

  @deck_list_page: you should be able to delete just like in @online_deck_browser
  
Now , ask me more defatiled questions for clarifications before doing executing
