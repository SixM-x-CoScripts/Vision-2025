/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-explicit-any */
// nique ta mere ça y est
import {
  SnackbarProvider,
  enqueueSnackbar,
  useSnackbar,
  closeSnackbar,
} from "notistack";
import Notification from "./components/Notification";
import { useEffect, useRef, useState } from "react";
import {
  // events,
  parseNotificationContentColors,
} from "./lib/utils";
import { Alert } from "./components/Alerts";
import { WeazelAnnouncements } from "./components/WeazelAnnouncements";

const Child = () => {
  useSnackbar();
  return <></>;
};

declare module "notistack" {
  interface VariantOverrides {
    reportComplete: true;
  }
}

export type WeazelNewsButton = {
  type: "info" | "music" | "price" | "interact" | "pos" | "time";
  text: string;
};

export type WeazelNews = {
  category: "fame" | "media" | "news" | "music";
  media: "image" | "video";
  media_url: string;
  buttons: WeazelNewsButton[];
  preview: boolean;
};

export type SnackbarKey = string | number;

export default function App() {
  const ref = useRef(null);
  const [props, setProps] = useState({});
  const [hud, setHud] = useState(true);
  const [weazel, setWeazel] = useState<any>([]);
  const [disabled, setDisabled] = useState(false);
  const [currentW, setCurrentW] = useState<WeazelNews | null>(null);
  const [previewWeazel, setPreviewWeazel] = useState<WeazelNews | null>(null);
  const [snackbarKeys, setSnackbarKeys] = useState<SnackbarKey[]>([]);
  const weazelRef = useRef(weazel);
  weazelRef.current = weazel;

  const handleEnqueueSnackbar = (message: string, options: any) => {
    const key = enqueueSnackbar(message, options);
    setSnackbarKeys((prevKeys: SnackbarKey[]) => [...prevKeys, key]);

    setTimeout(() => {
      if (snackbarKeys.includes(key)) {
        setSnackbarKeys((prevKeys: SnackbarKey[]) =>
          prevKeys.filter((k) => k !== key)
        );
        closeSnackbar(key);
      }
    }, options.autoHideDuration ?? 5000);
  };

  // si je choppe le fdp qui a fait le vnotif je lui nique sa mere
  const [alerts, setAlerts] = useState<
    {
      id: number;
      title: string;
      content: string;
      type: "info" | "error" | "success" | "warning" | "announcement";
    }[]
  >([]);
  // jsp genre tu fais en typescript BAH UTILISE LE CONNARD METS DES TYPES GENRE TYPES DANS TYPESCRIPT TU TE DIS PAS "AH OUAIS JVAIS METTRE DES TYPES" ET TU METS PAS DE TYPES
  // ça va vous?
  // ptn je vient de voir il a carrémemnt mit des regles eslint pour masquer sa merde

  const onMessage = (event: MessageEvent) => {
    const { action, data } = event.data;

    if (action === "__atoshi::disableNotifications") {
      setDisabled(data);
    }
    if (disabled) return;

    if (action === "__atoshi::removeNotification") {
      closeSnackbar(data);
    }

    if (action === "__atoshi::createNotification") {
      const { content, ...rest } = data;

      if (data.type === "WEAZEL") {
        setWeazel([...weazel, data]);
        return;
      }

      const {
        content: parsedContent,
        hasSpecialColor,
        color,
      } = parseNotificationContentColors(content, data.type);

      setProps({
        ...rest,
        parsedContent,
        hasSpecialColor,
        color,
        autoHideDuration: rest?.duration * 1000 ?? 5000,
      });

      const duration = (rest?.duration ?? 5) * 1000;
      handleEnqueueSnackbar(rest?.title ?? "", {
        key: new Date().getTime(),
        variant: "reportComplete",
        ...rest,
        parsedContent,
        hasSpecialColor,
        color,
        autoHideDuration: duration,
      });
    }
    if (action === "__atoshi::previewNotifications") {
      switch (data.type) {
        case "WEAZEL":
          setPreviewWeazel(data);
          break;
        default:
          setPreviewWeazel(null);
          break;
      }
    }
    if (action === "__atoshi::clearPreview") {
      setPreviewWeazel(null);
    }
    if (action === "__atoshi::updateNotificationHudState") {
      setHud(data);
    }
    // sa mere la pute ça fait peur le code ici
    if (action === "__atoshi::createAlert") {
      const id = new Date().getTime();
      setAlerts((alerts) => [...alerts, { id, ...data }]);
      setTimeout(() => {
        removeAlert(id);
      }, 10000);
    }
    if (action === "__atoshi::removeNewestNotification") {
      if (snackbarKeys.length > 0) {
        const latestKey = snackbarKeys[snackbarKeys.length - 1];
        setSnackbarKeys((prevKeys) => prevKeys.slice(0, -1));
        closeSnackbar(latestKey);
      }
    }
  };

  useEffect(() => {
    window.addEventListener("message", onMessage);
    return () => window.removeEventListener("message", onMessage);
  });

  const callback = () => {
    const _weazel = [...weazelRef.current];
    _weazel.shift();
    setCurrentW(null);
    setWeazel((__weazel: any) => _weazel);
  };

  useEffect(() => {
    if (weazel.length > 0 && !currentW) {
      setTimeout(callback, 11000, weazel);
      setCurrentW(weazel[0]);
    }
  }, [weazel]);

  const removeAlert = (id: number) => {
    setAlerts((alerts) => alerts.filter((alert) => alert.id !== id));
  };

  return (
    <div className={hud ? "hud" : ""}>
      {currentW && <WeazelAnnouncements announcement={currentW} />}
      {previewWeazel && <WeazelAnnouncements announcement={previewWeazel} />}

      {/* Default Vision Notifs (le truc qui pue la) */}
      <SnackbarProvider
        maxSnack={6}
        Components={{
          reportComplete: Notification,
        }}
      >
        <div
          style={{
            height: "100vh",
            width: "100vw",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
          }}
        >
          <Child />
          <div className="holder" ref={ref}>
            <Notification {...props} />
          </div>
        </div>
      </SnackbarProvider>

      {/* Les belles Alerts de Sacul, ça respire la rose */}
      <div className="alerts">
        {alerts.map((alert, index) => (
          <Alert key={index} alert={alert} />
        ))}
      </div>
    </div>
  );
}
