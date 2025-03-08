import { TextboxProps } from "../types/Menu.ts";

export default function Textbox(props: TextboxProps) {
  return (
    <article className="vui__textbox">
      {props.title && <h1 className="vui__textbox__title">{props.title}</h1>}
      <p className="vui__textbox__content">{props.content}</p>
    </article>
  );
}
