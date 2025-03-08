import dev_url from "./dev_url.ts";

export class Sound {
  private static clickSound = new Audio(dev_url("assets/sounds/click.mp3"));
  private static hoverSound = new Audio(dev_url("assets/sounds/hover.mp3"));
  private static notificationSound = new Audio(
    dev_url("assets/sounds/notification.mp3")
  );

  public static init() {
    this.clickSound.volume = 0.5;
    this.hoverSound.volume = 0.5;
  }

  private static play(sound: HTMLAudioElement) {
    // There is a little bug with the sound, when playing it multiple times in a row, it makes a weird noise
    // I need to fix it
    sound.pause();
    sound.currentTime = 0;
    sound.play();
  }

  public static click() {
    this.play(this.clickSound);
  }

  public static hover() {
    this.play(this.hoverSound);
  }

  public static notification() {
    this.play(this.notificationSound);
  }
}
