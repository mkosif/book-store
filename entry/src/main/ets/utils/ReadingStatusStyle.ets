import { ReadingStatus } from '../model/ReadingStatusService';

export function statusBackgroundColor(status: string | null): string {
  switch (status) {
    case ReadingStatus.TO_READ:
      return '#0057D9'
    case ReadingStatus.READING:
      return '#FFD23F'
    case ReadingStatus.READ:
      return '#00A65A'
    default:
      return '#4A4A4A'
  }
}

export function statusTextColor(status: string | null): string {
  if (status === ReadingStatus.READING) {
    return '#111111'
  }
  return '#FFFFFF'
}
