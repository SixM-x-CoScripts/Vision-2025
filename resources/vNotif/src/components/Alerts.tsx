import React, { useRef, useEffect } from "react";
import { CSSTransition } from "react-transition-group";

import NotifSoundAlert from "../assets/notification.mp3";

export type Alert = {
  id: number;
  title: string;
  content: string;
  type: "info" | "error" | "success" | "warning" | "announcement";
};

interface Props {
  alert: Alert;
}

export const Alert: React.FC<Props> = ({ alert }) => {
  const ref = useRef(null);

  useEffect(() => {
    const audio = new Audio(NotifSoundAlert);
    audio.play();
  }, []);

  return (
    <CSSTransition
      nodeRef={ref}
      in={true}
      appear={true}
      exit={true}
      timeout={300}
      unmountOnExit
    >
      <div className={`alert alert-${alert.type}`} ref={ref}>
        <h2 className="title">{alert.title}</h2>
        <p className="content">{alert.content}</p>
        <div className="loading-bar"></div>
      </div>
    </CSSTransition>
  );
};
