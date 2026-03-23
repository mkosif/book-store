import { StatsService } from '../model/StatsService';
import { ThemeService } from '../model/ThemeService';

@Builder
export function StatsPageBuilder() {
  StatsPage()
}

@Entry
@Component
struct StatsPage {
  @State stats: { toRead: number, reading: number, read: number, total: number } = { toRead: 0, reading: 0, read: 0, total: 0 }

  aboutToAppear() {
    this.stats = StatsService.getInstance().getReadingStats();
  }

  build() {
    NavDestination() {
      Column() {
        Text('Reading Statistics')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(ThemeService.getInstance().getTextColor())
          .margin({ top: 20, bottom: 20 })

        Column() {
          this.statRow('Total Books Tracked:', this.stats.total.toString())
          this.statRow('To Read:', this.stats.toRead.toString())
          this.statRow('Currently Reading:', this.stats.reading.toString())
          this.statRow('Books Read:', this.stats.read.toString())
        }
        .width('90%')
        .backgroundColor(ThemeService.getInstance().getCardBackgroundColor())
        .borderRadius(15)
        .padding(20)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(ThemeService.getInstance().getBackgroundColor())
    }
    .title('Stats')
    .hideBackButton(false)
  }

  @Builder
  statRow(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(16)
        .fontColor(ThemeService.getInstance().getTextColor())
      Blank()
      Text(value)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(ThemeService.getInstance().getTextColor())
    }
    .width('100%')
    .padding({ top: 10, bottom: 10 })
  }
}
