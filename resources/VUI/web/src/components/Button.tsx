import { ButtonProps } from "../types/Menu.ts";
import Icon from "./Icon.tsx";

export default function Button(props: ButtonProps) {
  // if props.rightLabel isn't a string, we default to an empty string
  if (props.rightLabel) {
    props.rightLabel =
      typeof props.rightLabel === "string"
        ? props.rightLabel
        : String(props.rightLabel);
  }
  // if a rightLabel is set and the content starts with a #, we assume it's a color
  let displayColor = props.rightLabel && props.rightLabel.indexOf("#") === 0;

  return (
    <article
      className={`vui__button ${props.selected ? "selected" : ""} ${
        props.disabled ? "disabled" : ""
      }`}
    >
      <h3
        className="vui__button__title"
        data-subtitle={props.subtitle}
        style={{
          fontWeight: props.subtitle ? 700 : 500,
        }}
      >
        {props.title}
      </h3>
      {props.rightLabel && !displayColor && (
        <span className="vui__button__right-label">{props.rightLabel}</span>
      )}
      {props.rightLabel && displayColor && (
        <span
          className="vui__button__right-label"
          style={{ backgroundColor: props.rightLabel }}
        >
          {props.rightLabel}
        </span>
      )}
      {props.icon && !props.rightLabel && (
        <Icon icon={props.icon} selected={props.selected} />
      )}
    </article>
  );
}
