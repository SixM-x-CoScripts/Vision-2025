import { CheckboxProps } from "../types/Menu.ts";
import Icon from "./Icon.tsx";
import { Icon as Icons } from "../types/Menu.ts";

export default function Checkbox(props: CheckboxProps) {
  return (
    <article
      className={`vui__checkbox ${props.selected ? "selected" : ""} ${
        props.disabled ? "disabled" : ""
      }`}
    >
      <h3
        className="vui__checkbox__title"
        data-subtitle={props.subtitle}
        style={{ fontWeight: props.subtitle ? 700 : 500 }}
      >
        {props.title}
      </h3>
      <Icon icon={props.checked ? Icons.CHECK : Icons.EMPTY} />
    </article>
  );
}
