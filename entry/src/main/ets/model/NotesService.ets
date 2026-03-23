export class NotesService {
  private static instance: NotesService;
  private notesMap: Record<string, string> = {};

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
    const saved = AppStorage.get<string>('BookNotesMap');
    if (saved) {
      try {
        this.notesMap = JSON.parse(saved) as Record<string, string>;
      } catch (e) {
        console.error('Failed to parse BookNotesMap');
      }
    }
  }

  private saveToStorage() {
    AppStorage.setOrCreate('BookNotesMap', JSON.stringify(this.notesMap));
  }

  getNote(bookTitle: string): string {
    return this.notesMap[bookTitle] ?? '';
  }

  setNote(bookTitle: string, note: string) {
    if (note.trim() === '') {
      const newMap: Record<string, string> = {};
      for (let key in this.notesMap) {
        if (key !== bookTitle) {
          newMap[key] = this.notesMap[key];
        }
      }
      this.notesMap = newMap;
    } else {
      this.notesMap[bookTitle] = note;
    }
    this.saveToStorage();
  }
}
