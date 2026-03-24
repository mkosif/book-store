import BookModel from './BookModel';

const FAVORITES_KEY = 'favorites';

export class FavoritesService {
  private static instance: FavoritesService;
  private favorites: BookModel[] = [];

  private constructor() {
    PersistentStorage.persistProp(FAVORITES_KEY, '');
    this.load();
  }

  static getInstance(): FavoritesService {
    if (!FavoritesService.instance) {
      FavoritesService.instance = new FavoritesService();
    }
    return FavoritesService.instance;
  }

  private load() {
    const stored = AppStorage.get<string>(FAVORITES_KEY);
    if (stored) {
      try {
        this.favorites = JSON.parse(stored) as BookModel[];
      } catch (e) {
        this.favorites = [];
      }
    }
  }

  private save() {
    AppStorage.setOrCreate(FAVORITES_KEY, JSON.stringify(this.favorites));
  }

  isFavorite(id: string): boolean {
    return this.favorites.some(b => b.id === id);
  }

  toggleFavorite(book: BookModel) {
    if (this.isFavorite(book.id)) {
      this.favorites = this.favorites.filter(b => b.id !== book.id);
    } else {
      this.favorites.push(book);
    }
    this.save();
  }

  getFavorites(): BookModel[] {
    return this.favorites;
  }
}
