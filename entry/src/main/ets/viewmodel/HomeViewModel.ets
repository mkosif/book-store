import BookModel from '../model/BookModel';
import { BookViewModel } from './BookViewModel';

@Observed
export class HomeViewModel {
  allBooks: BookModel[] = []
  private static _instance: HomeViewModel;

  private constructor() {
  }

  public static get instance(): HomeViewModel {
    if (!HomeViewModel._instance) {
      HomeViewModel._instance = new HomeViewModel();
    }
    return HomeViewModel._instance;
  }

  getBookOfDay(): BookModel | null {
    if (this.allBooks.length === 0) {
      return null;
    }
    const today = new Date();
    const dateHash = today.getFullYear() * 10000 + (today.getMonth() + 1) * 100 + today.getDate();
    const index = dateHash % this.allBooks.length;
    return this.allBooks[index];
  }

  async fetchBooks(uiContext?: UIContext) {
    await BookViewModel.instance.fetchBooks(uiContext);
    this.allBooks = BookViewModel.instance.allBooks;
  }
}
