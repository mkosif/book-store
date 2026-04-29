export class NotesService {
  private static instance: NotesService;
  private notesMap: Map<string, string> = new Map();

  private constructor() {
    this.loadFromStorage();
  }

  public static getInstance(): NotesService {
    if (!NotesService.instance) {
      NotesService.instance = new NotesService();
    }
    return NotesService.instance;
  }

  private loadFromStorage() {
    let saved = AppStorage.get<string>('BookNotesMap');
    if (saved) {
      try {
        let obj = JSON.parse(saved);
        this.notesMap = new Map(Object.entries(obj));
      } catch (e) {
        console.error('Failed to parse BookNotesMap');
      }
    }
  }

  private saveToStorage() {
    let obj = Object.fromEntries(this.notesMap);
    AppStorage.setOrCreate('BookNotesMap', JSON.stringify(obj));
  }

  getNote(bookTitle: string): string {
    return this.notesMap.get(bookTitle) ?? '';
  }

  setNote(bookTitle: string, note: string) {
    if (note.trim() === '') {
      this.notesMap.delete(bookTitle);
    } else {
      this.notesMap.set(bookTitle, note);
    }
    this.saveToStorage();
  }
}
