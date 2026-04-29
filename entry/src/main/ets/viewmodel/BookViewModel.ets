import BookModel from '../model/BookModel';
import BookService from '../model/BookService';

@Observed
export class BookViewModel {
  private static _instance: BookViewModel;
  allBooks: BookModel[] = []
  filteredBooks: BookModel[] = []
  categories: string[] = []
  selectedCategory: string = 'All'
  lastError: string = ''

  private constructor() {
  }

  public static get instance(): BookViewModel {
    if (!BookViewModel._instance) {
      BookViewModel._instance = new BookViewModel();
    }
    return BookViewModel._instance;
  }

  async fetchBooks(uiContext?: UIContext) {
    if (!uiContext) {
      console.error('UIContext is undefined. Cannot fetch books.')
      return;
    }

    try {
      this.lastError = ''
      this.allBooks = await BookService.getBooks(uiContext);
      console.info('BookViewModel Books:', JSON.stringify(this.allBooks, null, 3))
      this.updateCategories();
      this.applyFilter();
    } catch (err) {
      const error = err as Error
      this.lastError = error.message
      this.allBooks = []
      this.filteredBooks = []
      this.categories = ['All']
      console.error('Failed to fetch books:', error.message)
    }
  }

  private updateCategories() {
    const catSet = new Set<string>();
    this.allBooks.forEach(book => {
      if (book.categories) {
        book.categories.forEach(cat => catSet.add(cat));
      }
    });
    this.categories = ['All', ...Array.from(catSet)];
  }

  private applyFilter() {
    if (this.selectedCategory === 'All') {
      this.filteredBooks = [...this.allBooks];
    } else {
      this.filteredBooks = this.allBooks.filter(b =>
        b.categories && b.categories.includes(this.selectedCategory)
      );
    }
  }

  selectCategory(category: string) {
    this.selectedCategory = category;
    this.applyFilter();
  }

  addBook(book: BookModel) {
    if (this.allBooks.findIndex(b => b.id === book.id) >= 0) {
      return;
    }
    this.allBooks = [...this.allBooks, book];
    this.updateCategories();
    this.applyFilter();
  }
}
