import BookModel from './BookModel';

export class BookHistoryService {
  private static instance: BookHistoryService;
  private history: BookModel[] = [];
  private readonly MAX_HISTORY = 7;

  private constructor() {
    this.loadFromStorage();
  }

  public static getInstance(): BookHistoryService {
    if (!BookHistoryService.instance) {
      BookHistoryService.instance = new BookHistoryService();
    }
    return BookHistoryService.instance;
  }

  private loadFromStorage() {
    let saved = AppStorage.get<string>('BookHistory');
    if (saved) {
      try {
        this.history = JSON.parse(saved);
      } catch (e) {
        console.error('Failed to parse history');
      }
    }
  }

  private saveToStorage() {
    AppStorage.setOrCreate('BookHistory', JSON.stringify(this.history));
  }

  getHistory(): BookModel[] {
    return this.history;
  }

  addToHistory(book: BookModel) {
    const index = this.history.findIndex(b => b.title === book.title);
    if (index > -1) {
      this.history.splice(index, 1);
    }
    this.history.unshift(book);
    if (this.history.length > this.MAX_HISTORY) {
      this.history.pop();
    }
    this.saveToStorage();
  }
}
