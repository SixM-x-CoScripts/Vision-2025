import React from "react";
import Icon from "./Icon";
import { Icon as Icons } from "../types/Menu";

interface BanPreviewProps {
  banId: string;
  banRaison: string;
  banAt: string;
  banExpiration: string;
  banIdentifiers: string[];
}

export const BanPreview: React.FC<BanPreviewProps> = (banPreview) => {
  return (
    <div className="vui__menu__banPreview">
      <div className="vui__menu__banPreview__header">
        <h2 className="vui__menu__banPreview__header__title">
          Ban #{banPreview.banId}
        </h2>
        <div className="vui__menu__banPreview__header__time">
          <h2>{banPreview.banAt}</h2>
          <Icon icon={Icons.CLOCK} />
        </div>
      </div>
      <div className="vui__menu__banPreview__raison">
        <h2>Raison</h2>
        <p>{banPreview.banRaison}</p>
      </div>
      <div className="vui__menu__banPreview__identifiers">
        <h2>Identifiants</h2>
        <ul>
          {banPreview.banIdentifiers.map((identifier) => (
            <li>{identifier}</li>
          ))}
        </ul>
      </div>
      {String(banPreview.banId).includes("temp") && (
        <div className="vui__menu__banPreview__unbanWarning">
          <h1>Attention!</h1>
          <p>
            Ce ban comporte une ID temporaire, si vous souhaitez l'unban,
            veillez a bien unban l'ID unique aussi. Dans le cas contraire la
            personne sera toujours ban après un reboot!
          </p>
        </div>
      )}
      <p className="vui__menu__banPreview__expiration">
        {banPreview.banExpiration === "Jamais"
          ? "Ban permanent"
          : "Expire le " +
            new Date(Number(banPreview.banExpiration) * 1000).toLocaleString()}
      </p>
    </div>
  );
};
