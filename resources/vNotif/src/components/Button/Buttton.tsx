import React, {  } from "react";
import './style.scss'

const Button: React.FC<any> = ({
    label, height, width, fontSize, fontWeight, color, margin, callback, selected, padding, children, selectedStyle = {
        filter: 'brightness(1.1)'
    },
    disabled = false,
    readOnly = false,
}) => {

    return (
        <div onClick={() => {
            if (callback) callback();
        }}
            className={"buttonCustom " + color + " " + (disabled ? 'disabled' : '') + (readOnly ? 'readOnly' : '')}
            style={{
                height,
                width,
                fontSize,
                fontWeight,
                padding,
                margin,
                ...(selected ? { ...selectedStyle } : {})
            }}>{label}{children}</div>
    )
}

export default Button
