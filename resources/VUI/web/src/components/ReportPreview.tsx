import React from "react";
import Icon from "./Icon";
import { Icon as Icons } from "../types/Menu";

interface ReportPreviewProps {
  reportId: number;
  reportTime: string;
  reportMsg: string;
}

export const ReportPreview: React.FC<ReportPreviewProps> = (reportPreview) => {
  return (
    <div className="vui__menu__reportPreview">
      <div className="vui__menu__reportPreview__header">
        <h2 className="vui__menu__reportPreview__header__title">
          Report #{reportPreview.reportId}
        </h2>
        <div className="vui__menu__reportPreview__header__time">
          <h2>{reportPreview.reportTime}</h2>
          <Icon icon={Icons.CLOCK} />
        </div>
      </div>
      <p className="vui__menu__reportPreview__msg">{reportPreview.reportMsg}</p>
    </div>
  );
};
