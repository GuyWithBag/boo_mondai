// // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// // PATH: lib/providers/reviews_page_controller.dart
// // PURPOSE: Manages the FSRS spaced review session — due cards, flipping, rating
// // PROVIDERS: ReviewsPageController
// // HOOKS: none
// // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// import 'package:boo_mondai/models/models.barrel.dart';
// import 'package:boo_mondai/repositories/repositories.barrel.dart';
// import 'package:flutter/foundation.dart';
// import 'package:fsrs/fsrs.dart';

// import '../services/fsrs_service.dart';

// typedef ReviewItem = ({Card fsrsCard, DeckCard card});

// /// Loads all due FSRS cards, presents them one by one, applies ratings.
// class ReviewsPageController extends ChangeNotifier {
//   ReviewsPageController({
//     required FsrsCardRepository fsrsRepository,
//     required DeckCardRepository deckCardRepository,
//     required FsrsService fsrsService,
//     required ReviewLogRepository reviewLogRepository,
//     required StreakRepository streakRepository,
//   }) : _fsrsRepository = fsrsRepository,
//        _deckCardRepository = deckCardRepository,
//        _fsrsService = fsrsService,
//        _reviewLogRepository = reviewLogRepository,
//        _streakRepository = streakRepository;

//   final FsrsCardRepository _fsrsRepository;
//   final DeckCardRepository _deckCardRepository;
//   final FsrsService _fsrsService;
//   final ReviewLogRepository _reviewLogRepository;
//   final StreakRepository _streakRepository;

//   List<ReviewItem> _items = [];
//   int _currentIndex = 0;
//   bool _isFlipped = false;
//   bool _hasCountedStreak = false;
//   bool _isLoading = false;
//   String? _error;

//   List<ReviewItem> get items => _items;
//   ReviewItem? get currentItem =>
//       _items.isNotEmpty && _currentIndex < _items.length
//       ? _items[_currentIndex]
//       : null;
//   int get remainingCount =>
//       (_items.length - _currentIndex).clamp(0, _items.length);
//   bool get isFlipped => _isFlipped;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   bool get isComplete => _currentIndex >= _items.length && _items.isNotEmpty;

//   /// Loads all FSRS card states that are due now and joins with DeckCard data.
//   Future<void> load() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//     try {
//       final now = DateTime.now();
//       final dueStates = _fsrsRepository.getDueCards(now);
//       final joined = <ReviewItem>[];
//       for (final state in dueStates) {
//         final card = _deckCardRepository.getById(state.id);
//         if (card != null) {
//           joined.add((fsrsCard: state, card: card));
//         }
//       }
//       _items = joined;
//       _currentIndex = 0;
//       _isFlipped = false;
//       _hasCountedStreak = false;
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   /// Flips the current card to reveal the answer.
//   void flipCard() {
//     _isFlipped = !_isFlipped;
//     notifyListeners();
//   }

//   /// Applies [rating] to the current card, saves updates, advances to next.
//   Future<void> rateAndAdvance(Rating rating) async {
//     final item = currentItem;
//     if (item == null) return;
//     try {
//       final result = _fsrsService.reviewCard(item.fsrsCard.state, rating);
//       await _fsrsRepository.save(result.card);
//       await _reviewLogRepository.save(result.reviewLog);

//       if (!_hasCountedStreak) {
//         await _streakRepository.incrementStreak('local', DateTime.now());
//         _hasCountedStreak = true;
//       }

//       _currentIndex++;
//       _isFlipped = false;
//       notifyListeners();
//     } catch (e) {
//       _error = e.toString();
//       notifyListeners();
//     }
//   }

//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }
// }
