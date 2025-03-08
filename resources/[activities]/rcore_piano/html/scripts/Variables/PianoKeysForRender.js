function GetKeys(one, two, three){
    var PianoKeysForRender = [{
            Part: one,
            KeyNote: "C",
            SharpNote: "C#",

            BindKeyNote: GetDefaultKeyForNote("piano-C-" + one, 81), //Q
            BindKeySharpNote: GetDefaultKeyForNote("piano-C#-"+ one, 50), //Ě-2

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        {
            Part:  one,
            KeyNote: "D",
            SharpNote: "D#",

            BindKeyNote: GetDefaultKeyForNote("piano-D-"+ one, 87), //W
            BindKeySharpNote: GetDefaultKeyForNote("piano-D#-" + one, 51), //Š-3

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        {
            Part:  one,
            KeyNote: "E",
            SharpNote: null,

            BindKeyNote: GetDefaultKeyForNote("piano-E-" + one, 69), //E
            BindKeySharpNote: -9999,

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        {
            Part:  one,
            KeyNote: "F",
            SharpNote: "F#",

            BindKeyNote: GetDefaultKeyForNote("piano-F-" + one, 82), //R
            BindKeySharpNote: GetDefaultKeyForNote("piano-F#-" + one, 53), //Ř-5

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        {
            Part:  one,
            KeyNote: "G",
            SharpNote: "G#",

            BindKeyNote: GetDefaultKeyForNote("piano-G-" + one, 84), //T
            BindKeySharpNote: GetDefaultKeyForNote("piano-G#-" + one, 54), //Ž-6

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        {
            Part:  one,
            KeyNote: "A",
            SharpNote: "A#",

            BindKeyNote: GetDefaultKeyForNote("piano-A-" + one, 90), //Z-Y
            BindKeySharpNote: GetDefaultKeyForNote("piano-A#-" + one, 55), //Ý-7

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        {
            Part:  one,
            KeyNote: "B",
            SharpNote: null,

            BindKeyNote: GetDefaultKeyForNote("piano-B-" + one, 85), //U
            BindKeySharpNote: -9999,

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        ////////////////////
        {
            Part:  two,
            KeyNote: "C",
            SharpNote: "C#",

            BindKeyNote: GetDefaultKeyForNote("piano-C-" + two, 89), //Y-Z
            BindKeySharpNote: GetDefaultKeyForNote("piano-C#-" + two, 83), //S

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        {
            Part:  two,
            KeyNote: "D",
            SharpNote: "D#",

            BindKeyNote: GetDefaultKeyForNote("piano-D-" + two, 88), //X
            BindKeySharpNote: GetDefaultKeyForNote("piano-D#-" + two, 68), //D

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        {
            Part:  two,
            KeyNote: "E",
            SharpNote: null,

            BindKeyNote: GetDefaultKeyForNote("piano-E-" + two, 67), //C
            BindKeySharpNote: -9999, //

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        {
            Part:  two,
            KeyNote: "F",
            SharpNote: "F#",

            BindKeyNote: GetDefaultKeyForNote("piano-F-" + two, 86), //V
            BindKeySharpNote: GetDefaultKeyForNote("piano-F#-" + two, 71), //G

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        {
            Part:  two,
            KeyNote: "G",
            SharpNote: "G#",

            BindKeyNote: GetDefaultKeyForNote("piano-G-" + two, 66), //B
            BindKeySharpNote: GetDefaultKeyForNote("piano-G#-" + two, 72), //H

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        {
            Part:  two,
            KeyNote: "A",
            SharpNote: "A#",

            BindKeyNote: GetDefaultKeyForNote("piano-A-" + two, 78), //N
            BindKeySharpNote: GetDefaultKeyForNote("piano-A#-" + two, 74), //J

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        {
            Part:  two,
            KeyNote: "B",
            SharpNote: null,

            BindKeyNote: GetDefaultKeyForNote("piano-B-" + two, 77), //M
            BindKeySharpNote: -9999,

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        ////////////////////
        {
            Part:  three,
            KeyNote: "C",
            SharpNote: "C#",

            BindKeyNote: GetDefaultKeyForNote("piano-C-" + three, 63), // unknow player need to set this value him self
            BindKeySharpNote: GetDefaultKeyForNote("piano-C#-" + three, 63), // unknow player need to set this value him self

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        {
            Part:  three,
            KeyNote: "D",
            SharpNote: "D#",

            BindKeyNote: GetDefaultKeyForNote("piano-D-" + three, 63), // unknow player need to set this value him self
            BindKeySharpNote: GetDefaultKeyForNote("piano-D#-" + three, 63), // unknow player need to set this value him self

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        {
            Part:  three,
            KeyNote: "E",
            SharpNote: null,

            BindKeyNote: GetDefaultKeyForNote("piano-E-" + three, 63), // unknow player need to set this value him self
            BindKeySharpNote: -9999, //

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        {
            Part:  three,
            KeyNote: "F",
            SharpNote: "F#",

            BindKeyNote: GetDefaultKeyForNote("piano-F-" + three, 63), // unknow player need to set this value him self
            BindKeySharpNote: GetDefaultKeyForNote("piano-F#-" + three, 63), // unknow player need to set this value him self

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        {
            Part:  three,
            KeyNote: "G",
            SharpNote: "G#",

            BindKeyNote: GetDefaultKeyForNote("piano-G-" + three, 63), // unknow player need to set this value him self
            BindKeySharpNote: GetDefaultKeyForNote("piano-G#-" + three, 63), // unknow player need to set this value him self

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        {
            Part:  three,
            KeyNote: "A",
            SharpNote: "A#",

            BindKeyNote: GetDefaultKeyForNote("piano-A-" + three, 63), // unknow player need to set this value him self
            BindKeySharpNote: GetDefaultKeyForNote("piano-A#-" + three, 63), // unknow player need to set this value him self

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
        {
            Part:  three,
            KeyNote: "B",
            SharpNote: null,

            BindKeyNote: GetDefaultKeyForNote("piano-B-" + three, 63), // unknow player need to set this value him self
            BindKeySharpNote: -9999,

            Active: false,
            ActiveSharp: false,

            RecordingKey: false,
            RecordingSharpKey: false,
        },
    ]
    return PianoKeysForRender;
}