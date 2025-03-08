import { ListProps } from "../types/Menu.ts";
import Icon from "./Icon.tsx";
import { Icon as Icons } from "../types/Menu.ts";

export default function List(props: ListProps) {
  return (
    <article
      className={`vui__list ${props.selected ? "selected" : ""} ${
        props.disabled ? "disabled" : ""
      }`}
    >
      <h3
        className="vui__list__title"
        data-subtitle={props.subtitle}
        style={{ fontWeight: props.subtitle ? 700 : 500 }}
      >
        {props.title}
      </h3>
      {props.items && (
        <div>
          <Icon icon={Icons.CHEVRON} rotation={180} />
          <span className="vui__list__right-label">
            {props.items[props.index]}
          </span>
          <Icon icon={Icons.CHEVRON} />
        </div>
      )}
    </article>
  );
}
