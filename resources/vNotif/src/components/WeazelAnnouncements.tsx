import React from "react";
import { WeazelNews, WeazelNewsButton } from "../App";

import InfoIcon from "../assets/icons/info.svg";
import PosIcon from "../assets/icons/pos.svg";
import TimeIcon from "../assets/icons/time.svg";
import MusicIcon from "../assets/icons/music.svg";
import PriceIcon from "../assets/icons/price.svg";
import InteractIcon from "../assets/icons/interact.svg";

const ICONS: Record<string, any> = {
  info: InfoIcon,
  pos: PosIcon,
  time: TimeIcon,
  music: MusicIcon,
  price: PriceIcon,
  interact: InteractIcon,
};

export const WeazelAnnouncements: React.FC<{ announcement: WeazelNews }> = ({
  announcement,
}) => {
  return (
    <div className={`WeazelNewsShow ${announcement.preview ? "preview" : ""}`}>
      {announcement.preview && (
        <div className="preview">
          <span>Preview</span>
        </div>
      )}
      <img
        src={`https://cdn.sacul.cloud/v2/vision-cdn/vNotif/${announcement.category}.webp`}
      />
      <div className="content">
        {announcement.media === "image" ? (
          <img className="mainImg" src={announcement.media_url} />
        ) : (
          <video src={announcement.media_url} autoPlay />
        )}

        <div className="footer">
          {announcement.buttons.map(
            (button: WeazelNewsButton, index: number) => (
              <>
                {button.type === "interact" ? (
                  <div className="inter-btn" key={index}>
                    <span className="icon">E</span>
                    <span className="text">{button.text}</span>
                  </div>
                ) : (
                  <div key={index} className="btn">
                    <img src={ICONS[button.type]} />
                    <span>{button.text}</span>
                  </div>
                )}
              </>
            )
          )}
        </div>

        <div className="countdownbar" />
      </div>
    </div>
  );
};
