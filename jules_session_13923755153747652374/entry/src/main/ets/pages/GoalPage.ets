import { GoalService } from '../model/GoalService';
import { StatsService } from '../model/StatsService';
import { ThemeService } from '../model/ThemeService';

@Builder
export function GoalPageBuilder() {
  GoalPage()
}

@Entry
@Component
struct GoalPage {
  @State goal: number = 5
  @State currentRead: number = 0

  aboutToAppear() {
    this.goal = GoalService.getInstance().getGoal();
    this.currentRead = StatsService.getInstance().getReadingStats().read;
  }

  build() {
    NavDestination() {
      Column() {
        Text('Reading Goal')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(ThemeService.getInstance().getTextColor())
          .margin(20)

        Row() {
          Text('Monthly Goal: ')
            .fontColor(ThemeService.getInstance().getTextColor())
          Counter() {
            Text(this.goal.toString())
              .fontColor(ThemeService.getInstance().getTextColor())
          }
          .onInc(() => {
            this.goal++;
            GoalService.getInstance().setGoal(this.goal);
          })
          .onDec(() => {
            if (this.goal > 0) this.goal--;
            GoalService.getInstance().setGoal(this.goal);
          })
        }
        .padding(20)

        Progress({ value: this.currentRead, total: this.goal, type: ProgressType.Ring })
          .width(150)
          .height(150)
          .style({ strokeWidth: 10 })
          .margin(20)

        Text(`${this.currentRead} / ${this.goal} books read`)
          .fontSize(16)
          .fontColor(ThemeService.getInstance().getTextColor())
      }
      .width('100%')
      .height('100%')
      .backgroundColor(ThemeService.getInstance().getBackgroundColor())
    }
    .title('Goals')
    .hideBackButton(false)
  }
}
