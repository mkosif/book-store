import { ReadingStatus, ReadingStatusService } from './ReadingStatusService';

export interface ReadingStats {
  toRead: number;
  reading: number;
  read: number;
  total: number;
}

export class StatsService {
  private static instance: StatsService;

  private constructor() {}

  public static getInstance(): StatsService {
    if (!StatsService.instance) {
      StatsService.instance = new StatsService();
    }
    return StatsService.instance;
  }

  getReadingStats(): ReadingStats {
    const statusMap = ReadingStatusService.getInstance().getAllStatuses();
    const stats: ReadingStats = { toRead: 0, reading: 0, read: 0, total: 0 };
    statusMap.forEach((status: ReadingStatus) => {
      stats.total++;
      if (status === ReadingStatus.TO_READ) {
        stats.toRead++;
      } else if (status === ReadingStatus.READING) {
        stats.reading++;
      } else if (status === ReadingStatus.READ) {
        stats.read++;
      }
    });
    return stats;
  }
}
