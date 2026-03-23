import { StatsService, ReadingStats } from '../model/StatsService';

@Builder
export function StatsPageBuilder() {
  StatsPage()
}

@Entry
@Component
struct StatsPage {
  @State stats: ReadingStats = { toRead: 0, reading: 0, read: 0, total: 0 }

  aboutToAppear() {
    this.stats = StatsService.getInstance().getReadingStats();
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Text('‹')
            .fontSize(26)
            .fontColor('#FFFFFF')
            .width(40).height(40)
            .textAlign(TextAlign.Center)
            .backgroundColor('#444444')
            .borderRadius(20)
            .onClick(() => { this.pathStack.pop() })
        }
        .width('100%')
        .padding({ left: 28, top: 12, bottom: 4 })

        Text('📊')
          .fontSize(28)
          .margin({ top: 8, bottom: 8 })

        Grid() {
          GridItem() { this.statCard('📚', 'Total', this.stats.total) }
          GridItem() { this.statCard('📋', 'To Read', this.stats.toRead) }
          GridItem() { this.statCard('👁', 'Reading', this.stats.reading) }
          GridItem() { this.statCard('✅', 'Read', this.stats.read) }
        }
        .columnsTemplate('1fr 1fr')
        .rowsTemplate('1fr 1fr')
        .columnsGap(8)
        .rowsGap(8)
        .width('72%')
        .aspectRatio(1)
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
      .backgroundColor('#000000')
    }
    .hideTitleBar(true)
    .backgroundColor('#000000')
  }

  @Builder
  statCard(icon: string, label: string, value: number) {
    Column() {
      Text(icon).fontSize(18)
      Text(value.toString())
        .fontSize(20)
        .fontColor('#FFFFFF')
        .fontWeight(FontWeight.Bold)
        .margin({ top: 2 })
      Text(label)
        .fontSize(9)
        .fontColor('#666666')
        .margin({ top: 2 })
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
    .backgroundColor('#1A1A1A')
    .borderRadius(14)
  }
}
