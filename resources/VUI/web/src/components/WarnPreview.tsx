import React from "react";
import Icon from "./Icon";
import { Icon as Icons } from "../types/Menu";

interface WarnPreviewProps {
  warnId: string;
  warnReason: string;
  warnBy: string;
  warnAt: string;
  warnDiscord: string;
  warnLicense: string;
}

export const WarnPreview: React.FC<WarnPreviewProps> = (warnPreview) => {
  return (
    <div className="vui__menu__banPreview">
      <div className="vui__menu__banPreview__header">
        <h2 className="vui__menu__banPreview__header__title">
          Warn #{warnPreview.warnId}
        </h2>
        <div className="vui__menu__banPreview__header__time">
          <h2>
            {new Date(Number(warnPreview.warnAt) * 1000).toLocaleString()}
          </h2>
          <Icon icon={Icons.CLOCK} />
        </div>
      </div>
      <div className="vui__menu__banPreview__by">
        <h2>
          Par <span>{warnPreview.warnBy}</span>
        </h2>
      </div>
      <div className="vui__menu__banPreview__raison">
        <h2>Raison</h2>
        <p>{warnPreview.warnReason}</p>
      </div>
      <div className="vui__menu__banPreview__identifiers">
        <h2>Identifiants</h2>
        <ul>
          <li>{warnPreview.warnDiscord}</li>
          <li>{warnPreview.warnLicense}</li>
        </ul>
      </div>
    </div>
  );
};
