import { SearchInputProps } from "../types/Menu.ts";
import Icon from "./Icon.tsx";
import { Icon as Icons } from "../types/Menu.ts";

export default function SearchInput(props: SearchInputProps) {
  return (
    <article
      className={`vui__searchinput ${props.selected ? "selected" : ""} ${
        props.disabled ? "disabled" : ""
      }`}
    >
      {props.selected ? (
        <input
          type="text"
          className="vui__searchinput__input"
          placeholder="Rechercher..."
          onChange={(e) =>
            props.searchCallback && props.searchCallback(e.target.value)
          }
          autoFocus
          value={props.query || ""}
        />
      ) : (
        <h3
          className="vui__button__title"
          data-subtitle={props.subtitle}
          style={{
            fontWeight: props.subtitle ? 700 : 500,
          }}
        >
          {props.query || props.title}
        </h3>
      )}
      <Icon icon={Icons.SEARCH} />
    </article>
  );
}
