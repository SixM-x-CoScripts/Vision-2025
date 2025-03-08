export declare interface MenuProps {
  title?: string;
  footer?: string;
  banner?: Banner;
  index?: number;
  items: (
    | { type: "button"; props: ButtonProps }
    | { type: "unsearchableButton"; props: UnSearchableButtonProps }
    | { type: "checkbox"; props: CheckboxProps }
    | { type: "list"; props: ListProps }
    | { type: "separator"; props: SeparatorProps }
    | { type: "textbox"; props: TextboxProps }
    | { type: "imagebox"; props: ImageboxProps }
    | { type: "title"; props: TitleProps }
    | { type: "searchinput"; props: SearchInputProps }
    | { type: "imagebutton"; props: ImageButtonProps }
  )[];
  helpButtons?: { [key: string]: string };
  refresh?: boolean;
}

export declare interface RefreshProps {
  index?: number;
  items: (
    | { type: "button"; props: ButtonProps }
    | { type: "unsearchableButton"; props: UnSearchableButtonProps }
    | { type: "checkbox"; props: CheckboxProps }
    | { type: "list"; props: ListProps }
    | { type: "separator"; props: SeparatorProps }
    | { type: "textbox"; props: TextboxProps }
    | { type: "imagebox"; props: ImageboxProps }
    | { type: "title"; props: TitleProps }
    | { type: "searchinput"; props: SearchInputProps }
    | { type: "imagebutton"; props: ImageButtonProps }
  )[];
}

export declare interface ButtonProps {
  title: string;
  subtitle?: string;
  rightLabel?: string;
  icon?: Icon;
  disabled?: boolean;
  selected?: boolean;
}

export declare interface UnSearchableButtonProps {
  title: string;
  subtitle?: string;
  rightLabel?: string;
  icon?: Icon;
  disabled?: boolean;
  selected?: boolean;
}

export declare interface CheckboxProps {
  title: string;
  subtitle?: string;
  disabled?: boolean;
  selected?: boolean;
  checked?: boolean;
}

export declare interface ListProps {
  title: string;
  subtitle?: string;
  disabled?: boolean;
  selected?: boolean;
  items: string[];
  index: number;
}

export declare interface SeparatorProps {
  leftLabel?: string;
  leftValue?: string;
  rightLabel?: string;
  rightValue?: string;
  disabled?: boolean;
}

export declare interface TextboxProps {
  content: string;
  title?: string;
  disabled?: boolean;
}

export declare interface ImageboxProps {
  image1: string;
  image2?: string;
  disabled?: boolean;
}

export declare interface TitleProps {
  leftLabel?: string;
  leftValue?: string;
  rightLabel?: string;
  rightValue?: string;
  disabled?: boolean;
}

export declare interface SearchInputProps {
  title: string;
  subtitle?: string;
  disabled?: boolean;
  selected?: boolean;
  query?: string;
  searchCallback?: (query: string) => void;
}

export declare interface ImageButtonProps {
  title: string;
  image: string;
  disabled?: boolean;
  selected?: boolean;
}

export enum Banner {
  DEFAULT = "default",
  ANIMATIONS = "animations",
  ADMINISTRATION = "administration",
}

export enum Icon {
  HEART = "heart",
  ARROW = "arrow",
  CHEVRON = "chevron",
  CHECK = "check",
  EMPTY = "empty",
  SEARCH = "search",
  CLOCK = "clock",
  WARNING = "warning",
}

export declare interface IconProps {
  icon: Icon;
  rotation?: number;
  selected?: boolean;
}
