import { ImageboxProps } from "../types/Menu.ts";

export default function Imagebox(props: ImageboxProps) {
  return (
    <article className="vui__imagebox">
      <img className="vui__imagebox__img" src={props.image1} />
      {props.image2 && (
        <img className="vui__imagebox__img" src={props.image2} />
      )}
    </article>
  );
}
