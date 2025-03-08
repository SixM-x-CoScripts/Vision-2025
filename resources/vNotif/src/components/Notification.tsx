import { forwardRef } from "react";
import { SnackbarContent } from "notistack";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const ReportComplete = forwardRef<HTMLDivElement, any>(({ ...props }, ref) => {
  let distance = props.distance;
  let style = "red";
  let unit = "m";
  if (distance < 3000) style = "yellow";
  if (distance < 1000) style = "green";
  if (distance > 1000) {
    const num = Number(distance / 1000); // The Number() only visualizes the type and is not needed
    const roundedString = num.toFixed(1);
    distance = Number(roundedString);
    unit = "km";
  }

  let distancepnj = props.distancepnj;
  let style2 = "red";
  let unit2 = "m";
  if (distancepnj < 3000) style2 = "yellow";
  if (distancepnj < 1000) style2 = "green";
  if (distancepnj > 1000) {
    const num = Number(distancepnj / 1000); // The Number() only visualizes the type and is not needed
    const roundedString = num.toFixed(1);
    distancepnj = Number(roundedString);
    unit2 = "km";
  }

  /* useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === "n") {
        console.log("close snackbar", props.id);
        closeSnackbar(props.id);
        return;
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  }, [props]); */

  return (
    <SnackbarContent ref={ref}>
      {props.type === "VISION" ? (
        <div className="_notification showAnnonce">
          <div className="img">
            <img src="https://cdn.sacul.cloud/v2/vision-cdn/vNotif/vision.webp" />
          </div>
          <div className="infos">
            <div
              className="name A-FadeInLeft"
              style={{ animationDelay: "1.3s" }}
            >
              VISION
            </div>
            <div
              className={props.typeannonce.toLowerCase() + " A-FadeInLeft"}
              style={{ animationDelay: "1.6s" }}
            >
              {props.labeltype}
            </div>
            <div
              className="message A-FadeInLeft"
              style={{ animationDelay: "1.9s" }}
            >
              {props.parsedContent}
            </div>
          </div>
          {props.duration && (
            <div className="timer A-FadeIn" style={{ animationDelay: "2s" }}>
              <div
                className="track"
                style={
                  {
                    animationDuration: props.duration + "s",
                  } as React.CSSProperties
                }
              ></div>
            </div>
          )}
        </div>
      ) : props.type === "MISSIONTAXI" ? (
        <div className="notification police">
          <div className="top">
            <div style={{ marginLeft: 12.5 }}>{props.title}</div>
            {/* <div className="reason">{props.parsedContent}</div> */}

            <svg
              style={{ marginRight: 9 }}
              width="48"
              height="23"
              viewBox="0 0 48 23"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                d="M11.0969 21.0002C16.2331 21.0002 20.3969 16.7021 20.3969 11.4002C20.3969 6.09824 16.2331 1.80017 11.0969 1.80017C5.96063 1.80017 1.79688 6.09824 1.79688 11.4002C1.79688 16.7021 5.96063 21.0002 11.0969 21.0002Z"
                fill="black"
                fillOpacity="0.55"
              />
              <path
                d="M22.2 11.4C22.2 17.696 17.2304 22.8 11.1 22.8C4.96964 22.8 0 17.696 0 11.4C0 5.10395 4.96964 0 11.1 0C17.2304 0 22.2 5.10395 22.2 11.4ZM2.11657 11.4C2.11657 16.4955 6.13859 20.6262 11.1 20.6262C16.0614 20.6262 20.0834 16.4955 20.0834 11.4C20.0834 6.3045 16.0614 2.17378 11.1 2.17378C6.13859 2.17378 2.11657 6.3045 2.11657 11.4Z"
                fill="url(#paint0_linear_0_1)"
              />
              <path
                d="M12.195 12.23V15H10.505V12.23L7.86499 7.71503H9.35499C9.50166 7.71503 9.61666 7.75003 9.69999 7.82003C9.78666 7.8867 9.85832 7.97336 9.91499 8.08003L10.945 10.2C11.0317 10.3667 11.11 10.5233 11.18 10.67C11.25 10.8133 11.3117 10.955 11.365 11.095C11.415 10.9517 11.4717 10.8083 11.535 10.665C11.6017 10.5183 11.6783 10.3633 11.765 10.2L12.785 8.08003C12.8083 8.0367 12.8367 7.99336 12.87 7.95003C12.9033 7.9067 12.9417 7.86836 12.985 7.83503C13.0317 7.79836 13.0833 7.77003 13.14 7.75003C13.2 7.7267 13.265 7.71503 13.335 7.71503H14.835L12.195 12.23Z"
                fill="url(#paint1_linear_0_1)"
              />
              <path
                d="M36.0969 21C41.2331 21 45.3969 16.7019 45.3969 11.4C45.3969 6.09805 41.2331 1.79999 36.0969 1.79999C30.9606 1.79999 26.7969 6.09805 26.7969 11.4C26.7969 16.7019 30.9606 21 36.0969 21Z"
                fill="black"
                fillOpacity="0.55"
              />
              <path
                d="M47.2 11.4C47.2 17.696 42.2304 22.8 36.1 22.8C29.9696 22.8 25 17.696 25 11.4C25 5.10395 29.9696 0 36.1 0C42.2304 0 47.2 5.10395 47.2 11.4ZM27.1166 11.4C27.1166 16.4955 31.1386 20.6262 36.1 20.6262C41.0614 20.6262 45.0834 16.4955 45.0834 11.4C45.0834 6.3045 41.0614 2.17378 36.1 2.17378C31.1386 2.17378 27.1166 6.3045 27.1166 11.4Z"
                fill="url(#paint2_linear_0_1)"
              />
              <path
                d="M39.0651 7.71503V15H38.1851C38.0551 15 37.9451 14.98 37.8551 14.94C37.7684 14.8967 37.6818 14.8233 37.5951 14.72L34.1601 10.375C34.1734 10.505 34.1818 10.6317 34.1851 10.755C34.1918 10.875 34.1951 10.9883 34.1951 11.095V15H32.7051V7.71503H33.5951C33.6684 7.71503 33.7301 7.71836 33.7801 7.72503C33.8301 7.7317 33.8751 7.74503 33.9151 7.76503C33.9551 7.7817 33.9934 7.8067 34.0301 7.84003C34.0668 7.87336 34.1084 7.91836 34.1551 7.97503L37.6201 12.35C37.6034 12.21 37.5918 12.075 37.5851 11.945C37.5784 11.8117 37.5751 11.6867 37.5751 11.57V7.71503H39.0651Z"
                fill="url(#paint3_linear_0_1)"
              />
              <defs>
                <linearGradient
                  id="paint0_linear_0_1"
                  x1="11.1"
                  y1="0"
                  x2="11.1"
                  y2="22.8"
                  gradientUnits="userSpaceOnUse"
                >
                  <stop stopColor="#38DC66" />
                  <stop offset="1" stopColor="#33963C" />
                </linearGradient>
                <linearGradient
                  id="paint1_linear_0_1"
                  x1="524.237"
                  y1="2.00003"
                  x2="524.237"
                  y2="21.2"
                  gradientUnits="userSpaceOnUse"
                >
                  <stop stopColor="white" />
                  <stop offset="1" stopColor="#BFBFBF" />
                </linearGradient>
                <linearGradient
                  id="paint2_linear_0_1"
                  x1="36.1"
                  y1="0"
                  x2="36.1"
                  y2="22.8"
                  gradientUnits="userSpaceOnUse"
                >
                  <stop stopColor="#E01F1F" />
                  <stop offset="1" stopColor="#C21D30" />
                </linearGradient>
                <linearGradient
                  id="paint3_linear_0_1"
                  x1="548.237"
                  y1="2.00003"
                  x2="548.237"
                  y2="21.2"
                  gradientUnits="userSpaceOnUse"
                >
                  <stop stopColor="white" />
                  <stop offset="1" stopColor="#CDCDCD" />
                </linearGradient>
              </defs>
            </svg>
          </div>
          <div className="main">
            <div className="line">
              <img
                src="https://cdn.sacul.cloud/v2/vision-cdn/vNotif/person.svg"
                className="A-BounceIn"
                style={{ animationDelay: ".8s" }}
              />
              <div
                className="value A-FadeInLeft"
                style={{ textTransform: "uppercase", animationDelay: "1s" }}
              >
                {props.adress}
              </div>
            </div>
            <div className="line">
              <img
                src="https://cdn.sacul.cloud/v2/vision-cdn/vNotif/map.svg"
                className="A-BounceIn"
                style={{ animationDelay: ".8s" }}
              />
              <div
                className="value A-FadeInLeft "
                style={{ textTransform: "uppercase", animationDelay: "1s" }}
              >
                {props.adress2}
              </div>
            </div>
          </div>
          <div
            className={"distancepnj " + style2 + " A-BounceIn"}
            style={{ animationDelay: "1.3s" }}
          >
            {distancepnj}
            {unit2}
          </div>
          <div
            className={"distance " + style + " A-BounceIn"}
            style={{ animationDelay: "1.3s" }}
          >
            {distance}
            {unit}
          </div>
          {props.duration && (
            <div className="timer">
              <div
                className="track"
                style={
                  {
                    animationDuration: props.duration + "s",
                  } as React.CSSProperties
                }
              ></div>
            </div>
          )}
        </div>
      ) : props.type === "ALERTEJOBS" ? (
        <div className="notification police">
          <div className="top">
            <div style={{ display: "flex", alignItems: "center" }}>
              <div style={{ fontSize: 17, marginLeft: 12.5, marginRight: 8 }}>
                {props.title}
              </div>
              <svg
                width="10"
                height="10"
                viewBox="0 0 30 30"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <g filter="url(#filter0_d_1987_59)">
                  <circle
                    cx="14.9388"
                    cy="14.5968"
                    r="12.2903"
                    fill="url(#paint0_linear_1987_59)"
                  />
                </g>
                <defs>
                  <filter
                    id="filter0_d_1987_59"
                    x="0.648438"
                    y="0.806519"
                    width="28.5781"
                    height="28.5807"
                    filterUnits="userSpaceOnUse"
                    colorInterpolationFilters="sRGB"
                  >
                    <feFlood floodOpacity="0" result="BackgroundImageFix" />
                    <feColorMatrix
                      in="SourceAlpha"
                      type="matrix"
                      values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0"
                      result="hardAlpha"
                    />
                    <feOffset dy="0.5" />
                    <feGaussianBlur stdDeviation="1" />
                    <feComposite in2="hardAlpha" operator="out" />
                    <feColorMatrix
                      type="matrix"
                      values="0 0 0 0 0.219608 0 0 0 0 0.843137 0 0 0 0 0.388235 0 0 0 1 0"
                    />
                    <feBlend
                      mode="normal"
                      in2="BackgroundImageFix"
                      result="effect1_dropShadow_1987_59"
                    />
                    <feBlend
                      mode="normal"
                      in="SourceGraphic"
                      in2="effect1_dropShadow_1987_59"
                      result="shape"
                    />
                  </filter>
                  <linearGradient
                    id="paint0_linear_1987_59"
                    x1="14.9388"
                    y1="2.30652"
                    x2="14.9388"
                    y2="26.8872"
                    gradientUnits="userSpaceOnUse"
                  >
                    <stop stopColor="#38D964" />
                    <stop offset="1" stopColor="#33983D" />
                  </linearGradient>
                </defs>
              </svg>
            </div>
            {/* <div className="reason">{props.parsedContent}</div> */}

            <svg
              style={{ marginRight: 9 }}
              width="48"
              height="23"
              viewBox="0 0 48 23"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                d="M11.0969 21.0002C16.2331 21.0002 20.3969 16.7021 20.3969 11.4002C20.3969 6.09824 16.2331 1.80017 11.0969 1.80017C5.96063 1.80017 1.79688 6.09824 1.79688 11.4002C1.79688 16.7021 5.96063 21.0002 11.0969 21.0002Z"
                fill="black"
                fillOpacity="0.55"
              />
              <path
                d="M22.2 11.4C22.2 17.696 17.2304 22.8 11.1 22.8C4.96964 22.8 0 17.696 0 11.4C0 5.10395 4.96964 0 11.1 0C17.2304 0 22.2 5.10395 22.2 11.4ZM2.11657 11.4C2.11657 16.4955 6.13859 20.6262 11.1 20.6262C16.0614 20.6262 20.0834 16.4955 20.0834 11.4C20.0834 6.3045 16.0614 2.17378 11.1 2.17378C6.13859 2.17378 2.11657 6.3045 2.11657 11.4Z"
                fill="url(#paint0_linear_0_1)"
              />
              <path
                d="M12.195 12.23V15H10.505V12.23L7.86499 7.71503H9.35499C9.50166 7.71503 9.61666 7.75003 9.69999 7.82003C9.78666 7.8867 9.85832 7.97336 9.91499 8.08003L10.945 10.2C11.0317 10.3667 11.11 10.5233 11.18 10.67C11.25 10.8133 11.3117 10.955 11.365 11.095C11.415 10.9517 11.4717 10.8083 11.535 10.665C11.6017 10.5183 11.6783 10.3633 11.765 10.2L12.785 8.08003C12.8083 8.0367 12.8367 7.99336 12.87 7.95003C12.9033 7.9067 12.9417 7.86836 12.985 7.83503C13.0317 7.79836 13.0833 7.77003 13.14 7.75003C13.2 7.7267 13.265 7.71503 13.335 7.71503H14.835L12.195 12.23Z"
                fill="url(#paint1_linear_0_1)"
              />
              <path
                d="M36.0969 21C41.2331 21 45.3969 16.7019 45.3969 11.4C45.3969 6.09805 41.2331 1.79999 36.0969 1.79999C30.9606 1.79999 26.7969 6.09805 26.7969 11.4C26.7969 16.7019 30.9606 21 36.0969 21Z"
                fill="black"
                fillOpacity="0.55"
              />
              <path
                d="M47.2 11.4C47.2 17.696 42.2304 22.8 36.1 22.8C29.9696 22.8 25 17.696 25 11.4C25 5.10395 29.9696 0 36.1 0C42.2304 0 47.2 5.10395 47.2 11.4ZM27.1166 11.4C27.1166 16.4955 31.1386 20.6262 36.1 20.6262C41.0614 20.6262 45.0834 16.4955 45.0834 11.4C45.0834 6.3045 41.0614 2.17378 36.1 2.17378C31.1386 2.17378 27.1166 6.3045 27.1166 11.4Z"
                fill="url(#paint2_linear_0_1)"
              />
              <path
                d="M39.0651 7.71503V15H38.1851C38.0551 15 37.9451 14.98 37.8551 14.94C37.7684 14.8967 37.6818 14.8233 37.5951 14.72L34.1601 10.375C34.1734 10.505 34.1818 10.6317 34.1851 10.755C34.1918 10.875 34.1951 10.9883 34.1951 11.095V15H32.7051V7.71503H33.5951C33.6684 7.71503 33.7301 7.71836 33.7801 7.72503C33.8301 7.7317 33.8751 7.74503 33.9151 7.76503C33.9551 7.7817 33.9934 7.8067 34.0301 7.84003C34.0668 7.87336 34.1084 7.91836 34.1551 7.97503L37.6201 12.35C37.6034 12.21 37.5918 12.075 37.5851 11.945C37.5784 11.8117 37.5751 11.6867 37.5751 11.57V7.71503H39.0651Z"
                fill="url(#paint3_linear_0_1)"
              />
              <defs>
                <linearGradient
                  id="paint0_linear_0_1"
                  x1="11.1"
                  y1="0"
                  x2="11.1"
                  y2="22.8"
                  gradientUnits="userSpaceOnUse"
                >
                  <stop stopColor="#38DC66" />
                  <stop offset="1" stopColor="#33963C" />
                </linearGradient>
                <linearGradient
                  id="paint1_linear_0_1"
                  x1="524.237"
                  y1="2.00003"
                  x2="524.237"
                  y2="21.2"
                  gradientUnits="userSpaceOnUse"
                >
                  <stop stopColor="white" />
                  <stop offset="1" stopColor="#BFBFBF" />
                </linearGradient>
                <linearGradient
                  id="paint2_linear_0_1"
                  x1="36.1"
                  y1="0"
                  x2="36.1"
                  y2="22.8"
                  gradientUnits="userSpaceOnUse"
                >
                  <stop stopColor="#E01F1F" />
                  <stop offset="1" stopColor="#C21D30" />
                </linearGradient>
                <linearGradient
                  id="paint3_linear_0_1"
                  x1="548.237"
                  y1="2.00003"
                  x2="548.237"
                  y2="21.2"
                  gradientUnits="userSpaceOnUse"
                >
                  <stop stopColor="white" />
                  <stop offset="1" stopColor="#CDCDCD" />
                </linearGradient>
              </defs>
            </svg>
          </div>
          <div className="main">
            <div className="line">
              <img
                src="https://cdn.sacul.cloud/v2/vision-cdn/vNotif/info.svg"
                className=" A-BounceIn"
                style={{ animationDelay: ".8s" }}
              />
              <div
                className="value A-FadeInLeft"
                style={{ animationDelay: "1s" }}
              >
                {props.name.charAt(0).toUpperCase() + props.name.slice(1)}
              </div>
            </div>
            <div className="line">
              <img
                src="https://cdn.sacul.cloud/v2/vision-cdn/vNotif/map.svg"
                className=" A-BounceIn"
                style={{ animationDelay: ".8s" }}
              />
              <div
                className="value A-FadeInLeft "
                style={{ animationDelay: "1s" }}
              >
                {props.adress}
              </div>
            </div>
            <div className="line">
              <img
                src="https://cdn.sacul.cloud/v2/vision-cdn/vNotif/police.svg"
                className=" A-BounceIn"
                style={{ animationDelay: ".8s" }}
              />
              <div
                className="value A-FadeInLeft "
                style={{ animationDelay: "1s" }}
              >
                {props.utils}
              </div>
            </div>
          </div>
          <div
            className={"distance " + style + " A-BounceIn"}
            style={{ animationDelay: "1.3s" }}
          >
            {distance}
            {unit}
          </div>
          {props.duration && (
            <div className="timer">
              <div
                className="track"
                style={
                  {
                    animationDuration: props.duration + "s",
                  } as React.CSSProperties
                }
              ></div>
            </div>
          )}
        </div>
      ) : props.type === "JOB" ? (
        <div
          className={
            "_notification showAnnonce" + (props?.staffReason ? " staff" : "")
          }
        >
          <div className="img">
            <img src={props.logo} />
          </div>
          <div className="infos">
            <div
              className="name A-FadeInLeft"
              style={{ animationDelay: "1.3s" }}
            >
              {props.name}
            </div>
            <div
              className={props.typeannonce.toLowerCase() + " A-FadeInLeft"}
              style={{ animationDelay: "1.6s" }}
            >
              {props.typeannonce.toUpperCase()}
            </div>

            {props.staffReason == 1 && (
              <div
                style={{
                  fontSize: 10,
                  fontWeight: 300,
                  textTransform: "uppercase",
                  fontFamily: "Lato",
                  padding: "2px 8px",
                  borderRadius: 5,
                  marginBottom: 0,
                  width: "fit-content",
                  color: "#fff",
                  background:
                    "linear-gradient(180deg, rgba(253, 127, 127, 0.5) 0%, rgba(224, 31, 31, 0.5) 100%)",
                }}
              >
                {props?.overrideCategory ?? "Report RP"}
              </div>
            )}

            {props.staffReason == 2 && (
              <div
                style={{
                  fontSize: 10,
                  fontWeight: 300,
                  textTransform: "uppercase",
                  fontFamily: "Lato",
                  padding: "2px 8px",
                  borderRadius: 5,
                  width: "fit-content",
                  marginBottom: 0,
                  color: "#fff",
                  background:
                    "linear-gradient(180deg, rgba(251, 188, 4, 0.55) 0%, rgba(251, 157, 4, 0.55) 100%)",
                }}
              >
                {props?.overrideCategory ?? "REPORT BUG"}
              </div>
            )}

            {props.staffReason == 3 && (
              <div
                style={{
                  fontSize: 10,
                  fontWeight: 300,
                  textTransform: "uppercase",
                  fontFamily: "Lato",
                  padding: "2px 8px",
                  borderRadius: 5,
                  width: "fit-content",
                  color: "#fff",
                  marginBottom: 0,
                  background:
                    "linear-gradient(180deg, rgba(94, 108, 182, 0.8) 0%, rgba(94, 108, 182, 0.496) 100%)",
                }}
              >
                {props?.overrideCategory ?? "BOUTIQUE"}
              </div>
            )}

            {props.staffReason && (
              <div className="ReportAccept">
                <svg
                  style={{ marginRight: 9 }}
                  width="48"
                  height="23"
                  viewBox="0 0 48 23"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M11.0969 21.0002C16.2331 21.0002 20.3969 16.7021 20.3969 11.4002C20.3969 6.09824 16.2331 1.80017 11.0969 1.80017C5.96063 1.80017 1.79688 6.09824 1.79688 11.4002C1.79688 16.7021 5.96063 21.0002 11.0969 21.0002Z"
                    fill="black"
                    fillOpacity="0.55"
                  />
                  <path
                    d="M22.2 11.4C22.2 17.696 17.2304 22.8 11.1 22.8C4.96964 22.8 0 17.696 0 11.4C0 5.10395 4.96964 0 11.1 0C17.2304 0 22.2 5.10395 22.2 11.4ZM2.11657 11.4C2.11657 16.4955 6.13859 20.6262 11.1 20.6262C16.0614 20.6262 20.0834 16.4955 20.0834 11.4C20.0834 6.3045 16.0614 2.17378 11.1 2.17378C6.13859 2.17378 2.11657 6.3045 2.11657 11.4Z"
                    fill="url(#paint0_linear_0_1)"
                  />
                  <path
                    d="M12.195 12.23V15H10.505V12.23L7.86499 7.71503H9.35499C9.50166 7.71503 9.61666 7.75003 9.69999 7.82003C9.78666 7.8867 9.85832 7.97336 9.91499 8.08003L10.945 10.2C11.0317 10.3667 11.11 10.5233 11.18 10.67C11.25 10.8133 11.3117 10.955 11.365 11.095C11.415 10.9517 11.4717 10.8083 11.535 10.665C11.6017 10.5183 11.6783 10.3633 11.765 10.2L12.785 8.08003C12.8083 8.0367 12.8367 7.99336 12.87 7.95003C12.9033 7.9067 12.9417 7.86836 12.985 7.83503C13.0317 7.79836 13.0833 7.77003 13.14 7.75003C13.2 7.7267 13.265 7.71503 13.335 7.71503H14.835L12.195 12.23Z"
                    fill="url(#paint1_linear_0_1)"
                  />
                  <path
                    d="M36.0969 21C41.2331 21 45.3969 16.7019 45.3969 11.4C45.3969 6.09805 41.2331 1.79999 36.0969 1.79999C30.9606 1.79999 26.7969 6.09805 26.7969 11.4C26.7969 16.7019 30.9606 21 36.0969 21Z"
                    fill="black"
                    fillOpacity="0.55"
                  />
                  <path
                    d="M47.2 11.4C47.2 17.696 42.2304 22.8 36.1 22.8C29.9696 22.8 25 17.696 25 11.4C25 5.10395 29.9696 0 36.1 0C42.2304 0 47.2 5.10395 47.2 11.4ZM27.1166 11.4C27.1166 16.4955 31.1386 20.6262 36.1 20.6262C41.0614 20.6262 45.0834 16.4955 45.0834 11.4C45.0834 6.3045 41.0614 2.17378 36.1 2.17378C31.1386 2.17378 27.1166 6.3045 27.1166 11.4Z"
                    fill="url(#paint2_linear_0_1)"
                  />
                  <path
                    d="M39.0651 7.71503V15H38.1851C38.0551 15 37.9451 14.98 37.8551 14.94C37.7684 14.8967 37.6818 14.8233 37.5951 14.72L34.1601 10.375C34.1734 10.505 34.1818 10.6317 34.1851 10.755C34.1918 10.875 34.1951 10.9883 34.1951 11.095V15H32.7051V7.71503H33.5951C33.6684 7.71503 33.7301 7.71836 33.7801 7.72503C33.8301 7.7317 33.8751 7.74503 33.9151 7.76503C33.9551 7.7817 33.9934 7.8067 34.0301 7.84003C34.0668 7.87336 34.1084 7.91836 34.1551 7.97503L37.6201 12.35C37.6034 12.21 37.5918 12.075 37.5851 11.945C37.5784 11.8117 37.5751 11.6867 37.5751 11.57V7.71503H39.0651Z"
                    fill="url(#paint3_linear_0_1)"
                  />
                  <defs>
                    <linearGradient
                      id="paint0_linear_0_1"
                      x1="11.1"
                      y1="0"
                      x2="11.1"
                      y2="22.8"
                      gradientUnits="userSpaceOnUse"
                    >
                      <stop stopColor="#38DC66" />
                      <stop offset="1" stopColor="#33963C" />
                    </linearGradient>
                    <linearGradient
                      id="paint1_linear_0_1"
                      x1="524.237"
                      y1="2.00003"
                      x2="524.237"
                      y2="21.2"
                      gradientUnits="userSpaceOnUse"
                    >
                      <stop stopColor="white" />
                      <stop offset="1" stopColor="#BFBFBF" />
                    </linearGradient>
                    <linearGradient
                      id="paint2_linear_0_1"
                      x1="36.1"
                      y1="0"
                      x2="36.1"
                      y2="22.8"
                      gradientUnits="userSpaceOnUse"
                    >
                      <stop stopColor="#E01F1F" />
                      <stop offset="1" stopColor="#C21D30" />
                    </linearGradient>
                    <linearGradient
                      id="paint3_linear_0_1"
                      x1="548.237"
                      y1="2.00003"
                      x2="548.237"
                      y2="21.2"
                      gradientUnits="userSpaceOnUse"
                    >
                      <stop stopColor="white" />
                      <stop offset="1" stopColor="#CDCDCD" />
                    </linearGradient>
                  </defs>
                </svg>
              </div>
            )}

            <div
              className="message A-FadeInLeft"
              style={{ animationDelay: "1.9s" }}
            >
              {props.parsedContent}
            </div>
            <div
              className="phone A-FadeInUp"
              style={{
                marginRight: props.staff ? -13 : 0,
                animationDelay: "1.6s",
              }}
            >
              {props.phone}
            </div>
            {!props.staff && (
              <img
                className="phonelogo A-FadeInUp"
                src="https://cdn.sacul.cloud/v2/vision-cdn/vNotif/green-phone.webp"
                style={{ animationDelay: "1.6s" }}
              />
            )}
          </div>
          {props.duration && (
            <div className="timer A-FadeIn" style={{ animationDelay: "2s" }}>
              <div
                className="track"
                style={
                  {
                    animationDuration: props.duration + "s",
                  } as React.CSSProperties
                }
              ></div>
            </div>
          )}
        </div>
      ) : props.type === "ILLEGAL" ? (
        <div className="_notification showAnnonce illegal">
          <div className="img">
            <img src={props.logo} />
          </div>
          <div className="infos">
            <div
              className="name A-FadeInLeft"
              style={{ animationDelay: "1.3s" }}
            >
              {props.name}
            </div>

            <div
              style={{
                fontSize: 10,
                fontWeight: 300,
                textTransform: "uppercase",
                fontFamily: "Lato",
                padding: "2px 8px",
                borderRadius: 3,
                width: "fit-content",
                color: "#fff",
                background: `linear-gradient(180deg, ${props.labelColor}95 0%, ${props.labelColor}FF 100%)`,
              }}
            >
              {props.label}
            </div>

            <div
              className="message A-FadeInLeft"
              style={{ animationDelay: "1.9s" }}
            >
              {props.mainMessage}
            </div>
          </div>
          {props.duration && (
            <div className="timer A-FadeIn" style={{ animationDelay: "2s" }}>
              <div
                className="track"
                style={
                  {
                    animationDuration: props.duration + "s",
                  } as React.CSSProperties
                }
              ></div>
            </div>
          )}
        </div>
      ) : props.type === "ADMIN_NEW_REPORT" ? (
        <div className="_notification showAnnonce admin_new_report">
          <div className="top">
            <div className="name">
              <img src="https://cdn.sacul.cloud/v2/vision-cdn/vNotif/user_icon.webp" />
              {props.name}
            </div>
            <div className="id">{props.id}</div>
          </div>
          <div className="main">
            <div className="line">
              {props.subject.length > 180 ? (
                <div
                  className="value A-FadeInLeft"
                  style={{ animationDelay: "1s", fontSize: 12 }}
                >
                  {props.subject.substring(0, 180) + "..."}
                </div>
              ) : (
                <div
                  className="value A-FadeInLeft"
                  style={{ animationDelay: "1s" }}
                >
                  {props.subject}
                </div>
              )}
            </div>
            <div
              className="actions A-FadeInLeft"
              style={{ animationDelay: "1.3s" }}
            >
              <div className="action">
                <img src="https://cdn.sacul.cloud/v2/vision-cdn/vNotif/no_icon.webp" />
                <p>Masquer</p>
              </div>
              <div className="action">
                <p>Ouvrir</p>
                <img src="https://cdn.sacul.cloud/v2/vision-cdn/vNotif/yes_icon.webp" />
              </div>
            </div>
          </div>
          {props.duration && (
            <div className="timer">
              <div
                className="track"
                style={
                  {
                    animationDuration: props.duration + "s",
                  } as React.CSSProperties
                }
              ></div>
            </div>
          )}
        </div>
      ) : (
        <div
          style={
            { "--color": props.color, padding: "3px" } as React.CSSProperties
          }
          className={`notification ${
            props?.hasSpecialColor ? "--special-color" : ""
          }`}
          id={props.id}
        >
          <div className="left A-BounceIn" style={{ animationDelay: "0.8s" }}>
            <div
              className="icon__wrapper"
              dangerouslySetInnerHTML={{ __html: props.icon }}
            ></div>
          </div>

          <div
            className="right A-FadeInLeft"
            dangerouslySetInnerHTML={{ __html: props.parsedContent }}
            style={{ fontSize: 12, animationDelay: "1s" }}
          ></div>
          {props.duration && (
            <div className="timer">
              <div
                className="track"
                style={
                  {
                    animationDuration: props.duration + "s",
                  } as React.CSSProperties
                }
              ></div>
            </div>
          )}
        </div>
      )}
    </SnackbarContent>
  );
});

ReportComplete.displayName = "ReportComplete";

export default ReportComplete;
