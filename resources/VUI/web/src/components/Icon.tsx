import { IconProps } from "../types/Menu.ts";
import dev_url from "../utils/dev_url.ts";

export default function Icon(props: IconProps) {
  return (
    <small
      className={`vui__icon ${props.selected ? "selected" : ""}`}
      style={{ transform: `rotate(${props.rotation || 0}deg)` }}
    >
      <img src={dev_url(`assets/icons/${props.icon}.webp`)} alt="vui-icon" />
    </small>
  );
}
