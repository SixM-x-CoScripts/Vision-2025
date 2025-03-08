import { useState, useRef, useEffect } from "react";
import "./Menu.scss";

import { useNuiEvent } from "./hooks/useNuiEvent.ts";
import isDev from "./utils/isDev.ts";
import triggerNuiCallback from "./utils/triggerNuiCallback.ts";
import triggerNuiEvent from "./utils/triggerNuiEvent.ts";
import { Sound } from "./utils/sound.ts";
import dev_url from "./utils/dev_url.ts";

import Button from "./components/Button.tsx";
import Checkbox from "./components/Checkbox.tsx";
import Separator from "./components/Separator.tsx";
import List from "./components/List.tsx";
import Imagebox from "./components/Imagebox.tsx";
import Textbox from "./components/Textbox.tsx";
import Title from "./components/Title.tsx";
import SearchInput from "./components/SearchInput.tsx";
import ImageButton from "./components/ImageButton.tsx";

import { ReportPreview } from "./components/ReportPreview.tsx";
import { WarnPreview } from "./components/WarnPreview.tsx";
import { BanPreview } from "./components/BanPreview.tsx";

import {
  MenuProps,
  ButtonProps,
  CheckboxProps,
  SeparatorProps,
  ListProps,
  ImageboxProps,
  TextboxProps,
  TitleProps,
  SearchInputProps,
  ImageButtonProps,
  Banner,
} from "./types/Menu.ts";

const BANNED_ITEMS = ["imagebox", "textbox", "separator"];

export default function Menu() {
  Sound.init();

  const MAX_ITEMS = 10;

  const menuRef = useRef<HTMLElement>(null);
  const [menu, setMenu] = useState<MenuProps>({
    title: "",
    banner: Banner.DEFAULT,
    items: [],
    index: 0,
  });
  const [rawItems, setRawItems] = useState<MenuProps["items"]>([]);
  const [items, setItems] = useState<any[]>(menu.items.slice(0, MAX_ITEMS));
  const [index, setIndex] = useState(0);
  const [globalIndex, setGlobalIndex] = useState(0);

  const [searchQuery, setSearchQuery] = useState("");
  const [footer, setFooter] = useState("");

  const [reportPreview, setReportPreview] = useState<{
    reportId: number;
    reportTime: string;
    reportMsg: string;
  } | null>(null);
  const [warnPreview, setWarnPreview] = useState<{
    warnId: string;
    warnReason: string;
    warnBy: string;
    warnAt: string;
    warnDiscord: string;
    warnLicense: string;
  } | null>(null);
  const [banPreview, setBanPreview] = useState<{
    banId: string;
    banRaison: string;
    banAt: string;
    banExpiration: string;
    banIdentifiers: string[];
  } | null>(null);

  const goToFirstItem = () => {
    // Find the first item which is not disabled or a separator
    const i = menu.items.findIndex(
      (item) =>
        item.type !== "separator" &&
        item.type !== "textbox" &&
        item.type !== "imagebox" &&
        !item.props?.disabled
    );
    // If there is one, set it as the current item
    if (i !== -1) {
      setIndex(i);
      setGlobalIndex(i);
      if (i > MAX_ITEMS - 1) {
        setItems(menu.items.slice(i - (MAX_ITEMS - 1), i + 1));
        setIndex(MAX_ITEMS - 1);
      } else {
        setIndex(i);
        setItems(menu.items.slice(0, MAX_ITEMS));
      }
    }
  };

  const goToLastItem = () => {
    // Find the last item which is not disabled or a separator
    const i =
      menu.items.length -
      menu.items
        .slice()
        .reverse()
        .findIndex(
          (item) =>
            item.type !== "separator" &&
            item.type !== "imagebox" &&
            item.type !== "textbox" &&
            !item.props?.disabled
        ) -
      1;
    // If there is one, set it as the current item
    if (i !== -1) {
      setGlobalIndex(i);
      if (i > MAX_ITEMS - 1) {
        setItems(menu.items.slice(i - (MAX_ITEMS - 1), i + 1));
        setIndex(MAX_ITEMS - 1);
      } else {
        setItems(
          menu.items.slice(
            menu.items.length - MAX_ITEMS > 0
              ? menu.items.length - MAX_ITEMS
              : 0,
            menu.items.length
          )
        );
        setIndex(i);
      }
    }
    return i;
  };

  // Create a function that return the next item's index which is not disabled or not a separator
  const getNextAvailableIndex = (direction: "up" | "down") => {
    // This function is based on the global index
    let i = globalIndex;
    // Search for the item after the current one, if there is not, search from the beginning
    if (direction === "down") {
      i = menu.items.findIndex(
        (item, index) =>
          index > globalIndex &&
          item.type !== "separator" &&
          item.type !== "imagebox" &&
          item.type !== "textbox" &&
          item.type !== "title" &&
          !item.props?.disabled
      );
      if (i === -1) {
        return 0;
      }
      return i;
    } else {
      i = menu.items
        .slice()
        .reverse()
        .findIndex(
          (item, index) =>
            index > menu.items.length - globalIndex - 1 &&
            item.type !== "separator" &&
            item.type !== "imagebox" &&
            item.type !== "textbox" &&
            item.type !== "title" &&
            !item.props?.disabled
        );
      if (i === -1) {
        return menu.items.length - 1;
      }
      return menu.items.length - i - 1;
    }
  };

  const goDown = () => {
    const i = getNextAvailableIndex("down");
    let idx = 0;
    if (i !== index) {
      if (i && items.indexOf(menu.items[i]) === -1) {
        let newItems = menu.items.slice(i - (MAX_ITEMS - 1), i + 1);
        setItems(newItems);
        setIndex(MAX_ITEMS - 1);
        idx = menu.items.findIndex((item) => item === newItems[MAX_ITEMS - 1]);
        setGlobalIndex(idx);
      } else if (i) {
        setIndex(items.indexOf(menu.items[i]));
        setGlobalIndex(i);
        idx = i;
      } else goToFirstItem();
      triggerNuiCallback("vui:menu:indexChange", { index: idx });

      if (items[i] && items[i].type === "searchinput") {
        triggerNuiCallback("vui:menu:focus", {
          focus: true,
        });
      } else {
        triggerNuiCallback("vui:menu:focus", {
          focus: false,
        });
      }
    }
  };

  const goUp = () => {
    let i = getNextAvailableIndex("up");
    const _item = menu.items[i];
    if (items.indexOf(_item) !== -1) {
      if (i == menu.items.length - 1) {
        i = goToLastItem();
      } else {
        setIndex(items.indexOf(_item));
        setGlobalIndex(i);
      }
    } else {
      if (i == menu.items.length - 1) {
        i = goToLastItem();
      } else {
        let newItems = menu.items.slice(i, i + MAX_ITEMS);
        setItems(newItems);
        setIndex(0);
        setGlobalIndex(i);
      }
    }
    triggerNuiCallback("vui:menu:indexChange", { index: i });

    if (items[i] && items[i].type === "searchinput") {
      triggerNuiCallback("vui:menu:focus", {
        focus: true,
      });
    } else {
      triggerNuiCallback("vui:menu:focus", {
        focus: false,
      });
    }
  };

  const upListIndex = () => {
    if (items[index]?.type === "list") {
      const list = items[index].props as ListProps;
      list.index = list.index == list.items.length - 1 ? 0 : list.index + 1;
      setItems([...items]);
    }
  };

  const downListIndex = () => {
    if (items[index]?.type === "list") {
      const list = items[index].props as ListProps;
      list.index = list.index == 0 ? list.items.length - 1 : list.index - 1;
      setItems([...items]);
    }
  };

  const clickItem = () => {
    // If the item is disabled, don't do anything
    // @ts-ignore
    if (
      BANNED_ITEMS.includes(menu.items[globalIndex].type) ||
      menu.items[globalIndex].props?.disabled
    ) {
      return;
    }

    // If the item is a checkbox, toggle it
    if (items[index].type === "checkbox") {
      const checkbox = menu.items[globalIndex].props as CheckboxProps;
      checkbox.checked = !checkbox.checked;
      setItems([...items]);
    }

    // If the item is a searchinput, send a nui event to focus in, else focus out
    /* if (items[index].type === "searchinput") {
      triggerNuiCallback("vui:menu:focus", {
        focus: true,
      });
    } else {
      triggerNuiCallback("vui:menu:focus", {
        focus: false,
      });
    } */

    // Trigger the item's action
    triggerNuiCallback("vui:menu:click", {
      index: globalIndex,
      item: menu.items[globalIndex],
    });
  };

  const onSearchCallback = (query: string) => {
    setSearchQuery(query);
    triggerNuiCallback("vui:menu:search", query);

    if (query.length !== 0) {
      /*
      Fitler the items based on the query, search in props.title and props.subtitle
      
      Only button type can be searched, if there's any other type, it will be ignored and still displayed after the search
      */
      const filteredItems = rawItems.filter((item) => {
        if (item.type === "button") {
          return (
            item.props.title.toLowerCase().includes(query.toLowerCase()) ||
            (item.props.subtitle &&
              item.props.subtitle.toLowerCase().includes(query.toLowerCase()))
          );
        }
        return true;
      });
      // Update menu items with the filtered items
      setMenu({ ...menu, items: filteredItems });
      setItems(filteredItems.slice(0, MAX_ITEMS));
      triggerNuiCallback("vui:menu:filteritems", { items: filteredItems });
    } else {
      // If the query is empty, reset the items to the original items
      setMenu({ ...menu, items: rawItems });
      setItems(rawItems.slice(0, MAX_ITEMS));
      triggerNuiCallback("vui:menu:unfilteritems");
    }
  };

  useNuiEvent("nique:ta:mere:le:lua:ici:ca:console:log:mieux", (data: any) => {
    console.log(data);
  });

  // Open the menu when we receive the event, and display items
  useNuiEvent<MenuProps>("vui:menu", (data: MenuProps) => {
    setMenu(data);
    setRawItems(data.items);
    setSearchQuery("");

    // define a const indexDiff as the amount of usable items
    const indexDiff = data.items.filter(
      (item) =>
        item.type !== "separator" &&
        item.type !== "imagebox" &&
        item.type !== "textbox" &&
        item.type !== "title"
    ).length;
    const index = data.index || 0;

    // If the index is higher than the amount of usable items, set it to the last usable item
    if (index > indexDiff - 1) {
      setIndex(indexDiff - 1);
      setGlobalIndex(indexDiff - 1);
    } else {
      setIndex(index);
      setGlobalIndex(index);
    }

    // If the menu include a SearchInput in first position, focus it by default
    if (data.items.length && data.items[0].type === "searchinput") {
      triggerNuiCallback("vui:menu:focus", {
        focus: true,
      });
    }

    setIndex((data.index || 0) % MAX_ITEMS);
    if (data.index && data.index > MAX_ITEMS - 1) {
      setItems(data.items.slice(data.index - (MAX_ITEMS - 1), data.index + 1));
    } else {
      setItems(data.items.slice(0, MAX_ITEMS));
    }

    if (menuRef.current) menuRef.current.style.display = "flex";
  });

  // Close the menu when we receive the event, and reset items
  useNuiEvent("vui:menu:close", () => {
    setMenu({ title: "", banner: Banner.DEFAULT, items: [] });
    setItems([]);
    setIndex(0);
    setGlobalIndex(0);
    setFooter("");
    setReportPreview(null);
    setBanPreview(null);
    setWarnPreview(null);
    Sound.click();
    if (menuRef.current) menuRef.current.style.display = "none";
  });

  // Menu Footer
  useNuiEvent("vui:menu:footer", (data: { content: string; index: number }) => {
    setFooter(data.content);
  });

  // Report Preview
  useNuiEvent(
    "vui:menu:reportPreview",
    (data: {
      reportId: number;
      reportTime: string;
      reportMsg: string;
      index: number;
    }) => {
      data ? setReportPreview(data) : setReportPreview(null);
    }
  );

  // Ban Preview
  useNuiEvent(
    "vui:menu:banPreview",
    (data: {
      banId: string;
      banRaison: string;
      banAt: string;
      banExpiration: string;
      banIdentifiers: string[];
      index: number;
    }) => {
      data ? setBanPreview(data) : setBanPreview(null);
    }
  );

  // Warn Preview
  useNuiEvent(
    "vui:menu:warnPreview",
    (data: {
      warnId: string;
      warnReason: string;
      warnBy: string;
      warnAt: string;
      warnDiscord: string;
      warnLicense: string;
      index: number;
    }) => {
      data ? setWarnPreview(data) : setWarnPreview(null);
    }
  );

  // Close Report Preview
  useNuiEvent("vui:menu:closeReportPreview", () => {
    setReportPreview(null);
  });

  // Close Ban Preview
  useNuiEvent("vui:menu:closeBanPreview", () => {
    setBanPreview(null);
  });

  // Close Warn Preview
  useNuiEvent("vui:menu:closeWarnPreview", () => {
    setWarnPreview(null);
  });

  // Go up
  useNuiEvent("vui:menu:up", () => {
    if (menu.items.length === 0) return;
    goUp();
  });

  // Go down
  useNuiEvent("vui:menu:down", () => {
    if (menu.items.length === 0) return;
    goDown();
  });

  // Go left (only if the item is a list)
  useNuiEvent("vui:menu:left", () => {
    downListIndex();
    Sound.hover();
  });

  // Go right (only if the item is a list)
  useNuiEvent("vui:menu:right", () => {
    upListIndex();
    Sound.hover();
  });

  // Click the selected item
  useNuiEvent("vui:menu:click", () => {
    clickItem();
    Sound.click();
  });

  useNuiEvent<{
    index: number;
    item: {
      type:
        | "button"
        | "checkbox"
        | "separator"
        | "list"
        | "imagebox"
        | "textbox";
      props:
        | ButtonProps
        | CheckboxProps
        | ListProps
        | SeparatorProps
        | ImageboxProps
        | TextboxProps;
    };
  }>("vui:menu:update", (data) => {
    menu.items[data.index].props = data.item.props;
    setMenu({ ...menu });
    setItems(
      items.map((item, i) => {
        if (i === menu.items.findIndex((item) => item === items[index])) {
          return data.item;
        }
        return item;
      })
    );
  });

  useEffect(() => {
    // Add listeners for Up and Down Arrow Keys if the menu is open and the selected item is a search input
    // Since we're on the search input and focused in, game doesn't listen to the arrow keys anymore - we need to listen to them here
    const handleKeyDown = (e: KeyboardEvent) => {
      if (menuRef.current?.style.display === "flex") {
        if (
          (items[index] && items[index].type === "searchinput") ||
          (items[0] && items[0].type === "searchinput")
        ) {
          console.warn("VUI IS LISTENING TO ARROW KEYS");
          if (e.key === "ArrowUp") {
            console.log("UP");
            if (menu.items.length === 0) return;
            goUp();
            Sound.hover();
          }
          if (e.key === "ArrowDown") {
            console.log("DOWN");
            if (menu.items.length === 0) return;
            goDown();
            Sound.hover();
          }
          if (e.key === "Enter") {
            clickItem();
            Sound.click();
          }
          if (e.key === "Backspace" && searchQuery.length === 0) {
            triggerNuiCallback("vui:menu:focus", { focus: false });
            triggerNuiCallback("vui:menu:back");
          }
        }
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [index, items]);

  /* function debugRenderThousandsButtons() {
    // return an array of 1000 buttons with a random title and subtitle (random words, not numbers, only words)
    return Array.from({ length: 1000 }, (_, i) => ({
      type: "button",
      props: {
        title: Math.random().toString(36).substring(7),
        subtitle: Math.random().toString(36).substring(7),
      },
    }));
  } */

  if (isDev) {
    // Open a menu
    useEffect(() => {
      triggerNuiEvent<MenuProps>("vui:menu", {
        title: "Test menu",
        footer: "test",
        banner: Banner.DEFAULT,
        // @ts-ignore
        items: [
          { type: "title", props: { leftLabel: "Title", leftValue: "Value" } },
          { type: "searchinput", props: { title: "Search" } },
          { type: "separator", props: {} },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
          { type: "button", props: { title: "Button 1" } },
        ],
        helpButtons: {
          X: "Select",
        },
      });
    }, []);

    // Add listeners for Arrow Keys, Enter, Return and Escape
    useEffect(() => {
      const handleKeyDown = (e: KeyboardEvent) => {
        if (e.key === "ArrowUp") {
          triggerNuiEvent("vui:menu:up");
          Sound.hover();
        }
        if (e.key === "ArrowDown") {
          triggerNuiEvent("vui:menu:down");
          Sound.hover();
        }
        if (e.key === "ArrowLeft") {
          triggerNuiEvent("vui:menu:left");
          Sound.hover();
        }
        if (e.key === "ArrowRight") {
          triggerNuiEvent("vui:menu:right");
          Sound.hover();
        }
        if (e.key === "Enter") {
          triggerNuiEvent("vui:menu:click");
          Sound.click();
        }
        if (e.key === "Escape") {
          triggerNuiEvent("vui:menu:close");
          Sound.click();
        }
      };
      window.addEventListener("keydown", handleKeyDown);
      return () => window.removeEventListener("keydown", handleKeyDown);
    }, []);
  }

  return (
    <main className={isDev ? "dev_bg" : ""}>
      <section ref={menuRef} className="vui__menu">
        <img
          className="vui__menu__banner"
          src={dev_url(`assets/banners/${menu.banner}.webp`)}
          alt="vui-menu-banner"
        />
        <h2
          className="vui__menu__title"
          data-subtitle={`${globalIndex + 1} / ${menu.items.length}`}
        >
          {menu.title}
        </h2>
        <div className="vui__menu__body">
          {items.map((item, i) => {
            switch (item.type) {
              case "button":
                let button = item.props as ButtonProps;
                return <Button key={i} selected={index === i} {...button} />;
              case "checkbox":
                let checkbox = item.props as CheckboxProps;
                return (
                  <Checkbox key={i} selected={index === i} {...checkbox} />
                );
              case "separator":
                let separator = item.props as SeparatorProps;
                return <Separator key={i} {...separator} />;
              case "imagebox":
                let imagebox = item.props as ImageboxProps;
                return <Imagebox key={i} {...imagebox} />;
              case "textbox":
                let textbox = item.props as TextboxProps;
                return <Textbox key={i} {...textbox} />;
              case "list":
                let list = item.props as ListProps;
                return <List key={i} selected={index === i} {...list} />;
              case "title":
                let title = item.props as TitleProps;
                return <Title key={i} {...title} />;
              case "searchinput":
                let searchInput = item.props as SearchInputProps;
                return (
                  <SearchInput
                    key={i}
                    selected={index === i}
                    query={searchQuery}
                    searchCallback={onSearchCallback}
                    {...searchInput}
                  />
                );
              case "imagebutton":
                let imagebutton = item.props as ImageButtonProps;
                return (
                  <ImageButton
                    key={i}
                    selected={index === i}
                    {...imagebutton}
                  />
                );
              default:
                return null;
            }
          })}
        </div>
        {footer && <h2 className="vui__menu__footer">{footer}</h2>}

        {reportPreview && <ReportPreview {...reportPreview} />}
        {banPreview && <BanPreview {...banPreview} />}
        {warnPreview && <WarnPreview {...warnPreview} />}
      </section>
      <div className="vui__menu__help">
        {menu.helpButtons &&
          Object.keys(menu.helpButtons).map((key, i) => (
            <span key={i}>
              {menu.helpButtons![key]} <p>{key}</p>
            </span>
          ))}
      </div>
    </main>
  );
}
