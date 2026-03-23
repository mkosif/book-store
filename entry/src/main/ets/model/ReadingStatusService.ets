const READING_STATUS_KEY = 'readingStatus';

export enum ReadingStatus {
  NONE = 'None',
  TO_READ = 'To Read',
  READING = 'Reading',
  READ = 'Read'
}

export class ReadingStatusService {
  private static instance: ReadingStatusService;
  private statusMap: Map<string, ReadingStatus> = new Map();

  private constructor() {
    this.load();
  }

  static getInstance(): ReadingStatusService {
    if (!ReadingStatusService.instance) {
      ReadingStatusService.instance = new ReadingStatusService();
    }
    return ReadingStatusService.instance;
  }

  private load() {
    const stored = AppStorage.get<string>(READING_STATUS_KEY);
    if (stored) {
      try {
        const obj: Record<string, string> = JSON.parse(stored) as Record<string, string>;
        for (let key in obj) {
          this.statusMap.set(key, obj[key] as ReadingStatus);
        }
      } catch (e) {
        console.error('ReadingStatusService: failed to load:', e);
      }
    }
  }

  private save() {
    const obj: Record<string, string> = {};
    this.statusMap.forEach((value: ReadingStatus, key: string) => {
      obj[key] = value;
    });
    AppStorage.setOrCreate(READING_STATUS_KEY, JSON.stringify(obj));
  }

  getStatus(title: string): ReadingStatus {
    return this.statusMap.get(title) ?? ReadingStatus.NONE;
  }

  setStatus(title: string, status: ReadingStatus) {
    this.statusMap.set(title, status);
    this.save();
  }

  getAllStatuses(): Map<string, ReadingStatus> {
    return this.statusMap;
  }
}
