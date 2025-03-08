import { SeparatorProps } from "../types/Menu.ts";

export default function Separator(props: SeparatorProps) {
  return (
    <article className="vui__separator">
      <h3
        className="vui__separator__left-label"
        data-subtitle={props.leftValue}
        style={{ fontWeight: props.leftValue ? 700 : 400 }}
      >
        {props.leftLabel}
      </h3>
      {props.rightLabel && (
        <p
          className="vui__separator__right-label"
          data-subtitle={props.rightValue}
          style={{ fontWeight: props.rightValue ? 700 : 400 }}
        >
          {props.rightLabel}
        </p>
      )}
    </article>
  );
}
