import BookModel from './BookModel';
import { BookViewModel } from '../viewmodel/BookViewModel';

export class RecommendationService {
  private static instance: RecommendationService;

  private constructor() {}

  public static getInstance(): RecommendationService {
    if (!RecommendationService.instance) {
      RecommendationService.instance = new RecommendationService();
    }
    return RecommendationService.instance;
  }

  getRecommendations(): BookModel[] {
    const favoriteCategories = new Set<string>();
    let favoriteBooksSaved = AppStorage.get<string>('FavoriteBooks');
    if (favoriteBooksSaved) {
      try {
        let favorites = JSON.parse(favoriteBooksSaved) as BookModel[];
        favorites.forEach(b => b.categories.forEach(c => favoriteCategories.add(c)));
      } catch (e) {}
    }

    if (favoriteCategories.size === 0) {
      // Return random books if no favorites
      return BookViewModel.instance.allBooks.slice(0, 5);
    }

    return BookViewModel.instance.allBooks.filter(book => 
      book.categories.some(cat => favoriteCategories.has(cat))
    ).slice(0, 5);
  }
}
