import { TitleProps } from "../types/Menu.ts";

export default function Title(props: TitleProps) {
  return (
    <article className="vui__title">
      <h3
        className="vui__title__left-label"
        data-subtitle={props.leftValue}
        style={{ fontWeight: props.leftValue ? 700 : 400 }}
      >
        {props.leftLabel}
      </h3>
      {props.rightLabel && (
        <p
          className="vui__title__right-label"
          data-subtitle={props.rightValue}
          style={{ fontWeight: props.rightValue ? 700 : 400 }}
        >
          {props.rightLabel}
        </p>
      )}
    </article>
  );
}
