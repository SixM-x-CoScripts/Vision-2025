var CHandlingData = {
    fMass: {
        Label: 'Mass',
        Group: 'Body',
        Min: {
            value: '100',
            changeLimit: '0',
        },
        Max: {
            value: '60000',
            changeLimit: '0',
        },
        Description: 'This is the weight of the vehicle in kilograms. Only used when the vehicle collides with another vehicle or non-static object.',
    },
    fInitialDragCoeff: {
        Label: 'Drag coefficient',
        Group: 'Aero',
        Min: {
            value: '0.9',
            changeLimit: '0',
        },
        Max: {
            value: '300',
            changeLimit: '0',
        },
        Description: 'Sets the drag coefficient on the rage physics archetype of the vehicle (proportional to velocity squared). Increase to simulate aerodynamic drag.',
    },
    fPercentSubmerged: {
        Label: 'Water floating percentage',
        Group: 'Other',
        Min: {
            value: '45',
            changeLimit: '0',
        },
        Max: {
            value: '200',
            changeLimit: '0',
        },
        Description: "A percentage of vehicle height in the water before vehicle 'floats'. So as the vehicle falls into the water, at 85% vehicle height (seemingly the default for road vehicles) it will stop sinking to float for a moment before it sinks (boats excluded).",
    },
    fDriveBiasFront: {
        Label: 'Drive front bias',
        Group: 'Engine',
        Min: {
            value: '0',
            changeLimit: '0',
        },
        Max: {
            value: '1',
            changeLimit: '0',
        },
        Description: 'This value determines how much power is passed to front wheels, if value is 0, car will be rear wheels drive, 100 - front wheel drive, anything in between will make vehicle four wheels drive.',
    },
    nInitialDriveGears: {
        Label: 'Amount of gears',
        Group: 'Engine',
        Min: {
            value: '1',
            changeLimit: '0',
        },
        Max: {
            value: '10',
            changeLimit: '0',
        },
        Description: 'How many forward speeds a transmission contains.',
    },
    fInitialDriveForce: {
        Label: 'Drive force',
        Group: 'Engine',
        Min: {
            value: '0',
            changeLimit: '0',
        },
        Max: {
            value: '5',
            changeLimit: '0',
        },
        Description: "This multiplier modifies the game's calculation of drive force (from the output of the transmission).",
    },
    fDriveInertia: {
        Label: 'Drive inertia',
        Group: 'Engine',
        Min: {
            value: '0.1',
            changeLimit: '0',
        },
        Max: {
            value: '2.5',
            changeLimit: '0',
        },
        Description: 'Describes how fast an engine will rev. For example an engine with a long stroke crank and heavy flywheel will take longer to redline than an engine with a short stroke and light flywheel.',
    },
    fClutchChangeRateScaleUpShift: {
        Label: 'Shift UP speed',
        Group: 'Engine',
        Min: {
            value: '0.3',
            changeLimit: '0',
        },
        Max: {
            value: '9',
            changeLimit: '0',
        },
        Description: 'Clutch speed multiplier on up shifts, bigger number = faster shifts.',
    },
    fClutchChangeRateScaleDownShift: {
        Label: 'Shift DOWN speed',
        Group: 'Engine',
        Min: {
            value: '0.3',
            changeLimit: '0',
        },
        Max: {
            value: '9',
            changeLimit: '0',
        },
        Description: 'Clutch speed multiplier on down shifts, bigger number = faster shifts.',
    },
    fInitialDriveMaxFlatVel: {
        Label: 'Max Speed',
        Group: 'Engine',
        Min: {
            value: '10',
            changeLimit: '0',
        },
        Max: {
            value: '328.6',
            changeLimit: '0',
        },
        Description: 'Determines the speed at redline in top gear. Setting this value does not guarantee the vehicle will reach this speed. Multiply the number in the file by 0-82 to get the speed in mph or multiply by 1.32 to get kph.',
    },
    fBrakeForce: {
        Label: 'Braking force',
        Group: 'Brakes',
        Min: {
            value: '0.001',
            changeLimit: '0',
        },
        Max: {
            value: '5',
            changeLimit: '0',
        },
        Description: "Multiplies the game's calculation of deceleration. Bigger number = harder braking.",
    },
    fBrakeBiasFront: {
        Label: 'Brake front bias',
        Group: 'Brakes',
        Min: {
            value: '0',
            changeLimit: '0',
        },
        Max: {
            value: '0.8',
            changeLimit: '0',
        },
        Description: 'This controls the distribution of braking force between the front and rear axles.',
    },
    fHandBrakeForce: {
        Label: 'Hand Brake force',
        Group: 'Brakes',
        Min: {
            value: '0.01',
            changeLimit: '0',
        },
        Max: {
            value: '6',
            changeLimit: '0',
        },
        Description: 'Braking power for handbrake. Bigger number = harder braking.',
    },
    fSteeringLock: {
        Label: 'Steering lock',
        Group: 'Suspension',
        Min: {
            value: '20',
            changeLimit: '0',
        },
        Max: {
            value: '90',
            changeLimit: '0',
        },
        Description: "This value is a multiplier of the game's calculation of the angle a steer wheel will turn while at full turn. Steering lock is directly related to over or understeer / turning radius.",
    },
    fTractionCurveMax: {
        Label: 'Traction curve max',
        Group: 'Traction',
        Min: {
            value: '0',
            changeLimit: '1.3',
        },
        Max: {
            value: '3.7',
            changeLimit: '05',
        },
        Description: 'Cornering grip of the vehicle as a multiplier of the tire surface friction.',
    },
    fTractionCurveMin: {
        Label: 'Traction curve min',
        Group: 'Traction',
        Min: {
            value: '0',
            changeLimit: '0',
        },
        Max: {
            value: '3.5',
            changeLimit: '0',
        },
        Description: 'Accelerating/braking grip of the vehicle as a multiplier of the tire surface friction.',
    },
    fTractionCurveLateral: {
        Label: 'Traction curve lateral',
        Group: 'Traction',
        Min: {
            value: '1',
            changeLimit: '0',
        },
        Max: {
            value: '120',
            changeLimit: '0',
        },
        Description: 'Shape of lateral traction curve (peak traction position in degrees).',
    },
    fTractionSpringDeltaMax: {
        Label: 'Traction spring delta max',
        Group: 'Traction',
        Min: {
            value: '0.02',
            changeLimit: '0',
        },
        Max: {
            value: '0.5',
            changeLimit: '0',
        },
        Description: 'This value denotes at what distance above the ground the car will lose traction.',
    },
    fLowSpeedTractionLossMult: {
        Label: 'Traction loss multiplier',
        Group: 'Suspension',
        Min: {
            value: '0',
            changeLimit: '0',
        },
        Max: {
            value: '2.2',
            changeLimit: '0',
        },
        Description: "How much traction is reduced at low speed, 0.0 means normal traction. It affects mainly car burnout (spinning wheels when car doesn't move) when pressing gas. Decreasing value will cause less burnout, less sliding at start. However, the higher value, the more burnout car gets. Optimal is 1.0.",
    },
    fCamberStiffnesss: {
        Label: 'Camber stiffness',
        Group: 'Suspension',
        Min: {
            value: '0',
            changeLimit: '0',
        },
        Max: {
            value: '1.12',
            changeLimit: '0',
        },
        Description: "This value modify the grip of the car when you're drifting and you release the gas. In general, it makes your car slide more on sideways movement. More than 0 make the car sliding on the same angle you're drifting and less than 0 make your car oversteer (not recommend to use more than 0.1 / -0.1 if you don't know what you're doing).",
    },
    fTractionBiasFront: {
        Label: 'Traction front bias',
        Group: 'Traction',
        Min: {
            value: '0.325',
            changeLimit: '0',
        },
        Max: {
            value: '0.95',
            changeLimit: '0',
        },
        Description: 'Determines the distribution of traction from front to rear.',
    },
    fTractionLossMult: {
        Label: 'Traction loss multiplier',
        Group: 'Traction',
        Min: {
            value: '0',
            changeLimit: '0',
        },
        Max: {
            value: '1.4',
            changeLimit: '0',
        },
        Description: 'How much is traction affected by material grip differences from 1.0. Basically it affects how much grip is changed when driving on asphalt and mud (the higher, the more grip you loose, making car less responsive and prone to sliding).',
    },
    fSuspensionForce: {
        Label: 'Suspension stiffness',
        Group: 'Suspension',
        Min: {
            value: '0',
            changeLimit: '0',
        },
        Max: {
            value: '9',
            changeLimit: '0',
        },
        Description: '1 / (Force * NumWheels) = Lower limit for zero force at full extension. Affects how strong suspension is. Can help if car is easily flipped over when turning.',
    },
    fSuspensionCompDamp: {
        Label: 'Suspenssion damper comp stiffness',
        Group: 'Suspension',
        Min: {
            value: '0',
            changeLimit: '0',
        },
        Max: {
            value: '8',
            changeLimit: '0',
        },
        Description: 'Damping during strut compression. Bigger = stiffer.',
    },
    fSuspensionReboundDamp: {
        Label: 'Suspension rebound damp stiffness',
        Group: 'Suspension',
        Min: {
            value: '0',
            changeLimit: '0',
        },
        Max: {
            value: '10.8',
            changeLimit: '0',
        },
        Description: 'Damping during strut rebound. Bigger = stiffer.',
    },
    fSuspensionUpperLimit: {
        Label: 'Suspension upper limit',
        Group: 'Suspension',
        Min: {
            value: '0',
            changeLimit: '0',
        },
        Max: {
            value: '0.8',
            changeLimit: '0',
        },
        Description: 'Visual limit... how far can wheels move up / down from original position.',
    },
    fSuspensionLowerLimit: {
        Label: 'Suspension lower limit',
        Group: 'Suspension',
        Min: {
            value: '-0.36',
            changeLimit: '0',
        },
        Max: {
            value: '0.1',
            changeLimit: '0',
        },
        Description: 'Visual limit... how far can wheels move up / down from original position.',
    },
    fSuspensionRaise: {
        Label: 'Suspension height',
        Group: 'Suspension',
        Min: {
            value: '-0.085',
            changeLimit: '0',
        },
        Max: {
            value: '0.35',
            changeLimit: '0',
        },
        Description: 'The amount that the suspension raises the body off the wheels. Recommend adjusting at second decimal unless vehicle has room to move. ie -0.02 is plenty of drop on an already low car. Too much will show the wheels clipping through or if positive, no suspension joining the body to wheels.',
    },
    fSuspensionBiasFront: {
        Label: 'Suspension front bias',
        Group: 'Suspension',
        Min: {
            value: '0',
            changeLimit: '0',
        },
        Max: {
            value: '0.85',
            changeLimit: '0',
        },
        Description: 'Force damping scale front/back. If more wheels at back (e.g. trucks) need front suspension to be stronger. This value determines which suspension is stronger, front or rear. If value is above 0.50 then front is stiffer, when below, rear.',
    },
    fAntiRollBarForce: {
        Label: 'Antiroll bar stiffness',
        Group: 'Suspension',
        Min: {
            value: '0',
            changeLimit: '0',
        },
        Max: {
            value: '3',
            changeLimit: '0',
        },
        Description: 'The spring constant that is transmitted to the opposite wheel when under compression larger numbers are a larger force. Larger Numbers = less body roll.',
    },
    fAntiRollBarBiasFront: {
        Label: 'Front Antiroll bar stiffness',
        Group: 'Suspension',
        Min: {
            value: '0',
            changeLimit: '0',
        },
        Max: {
            value: '1',
            changeLimit: '0',
        },
        Description: 'The bias between front and rear for the antiroll bar(0 front, 1 rear).',
    },
    fRollCentreHeightFront: {
        Label: 'Roll centre height front',
        Group: 'Suspension',
        Min: {
            value: '0',
            changeLimit: '0',
        },
        Max: {
            value: '1.2',
            changeLimit: '0',
        },
        Description: 'This value modify the weight transmission during an acceleration between the left and right.',
    },
    fRollCentreHeightRear: {
        Label: 'Roll centre height rear',
        Group: 'Suspension',
        Min: {
            value: '0',
            changeLimit: '0',
        },
        Max: {
            value: '1.2',
            changeLimit: '0',
        },
        Description: 'This value modify the weight transmission during an acceleration between the front and rear (and can affect the acceleration speed).',
    },
    fCollisionDamageMult: {
        Label: 'Crash damage multiplier',
        Group: 'Damage',
        Min: {
            value: '0.005',
            changeLimit: '0',
        },
        Max: {
            value: '2',
            changeLimit: '0',
        },
        Description: "Multiplies the game's calculation of damage to the vehicle through collision.",
    },
    fWeaponDamageMult: {
        Label: 'Weapon damage multiplier',
        Group: 'Damage',
        Min: {
            value: '0.03',
            changeLimit: '0',
        },
        Max: {
            value: '4',
            changeLimit: '0',
        },
        Description: "Multiplies the game's calculation of damage to the vehicle through weapon damage.",
    },
    fDeformationDamageMult: {
        Label: 'Deformation multiplier',
        Group: 'Damage',
        Min: {
            value: '0',
            changeLimit: '0',
        },
        Max: {
            value: '5',
            changeLimit: '0',
        },
        Description: "Multiplies the game's calculation of deformation-causing damage.",
    },
    fEngineDamageMult: {
        Label: 'Engine damage multiplier',
        Group: 'Damage',
        Min: {
            value: '0.01',
            changeLimit: '0',
        },
        Max: {
            value: '2.5',
            changeLimit: '0',
        },
        Description: "Multiplies the game's calculation of damage to the engine, causing explosion or engine failure.",
    },
    fPetrolTankVolume: {
        Label: 'Fuel tank volume',
        Min: {
            value: '0',
            changeLimit: '0',
        },
        Max: {
            value: '5000',
            changeLimit: '0',
        },
        Description: "Amount of petrol that will leak after shooting the vehicle's petrol tank.",
    },
    fOilVolume: {
        Label: 'Oil volume',
        Min: {
            value: '0',
            changeLimit: '0',
        },
        Max: {
            value: '10',
            changeLimit: '0',
        },
        Description: 'Black smoke time before engine dies?',
    },
    fSeatOffsetDistX: {
        Label: 'Seat offset X',
        Editable: 'false',
        Min: {
            value: '-0.2',
            changeLimit: '0',
        },
        Max: {
            value: '0.3',
            changeLimit: '0',
        },
        Description: 'The distance from the door to the car seat.',
    },
    fSeatOffsetDistY: {
        Label: 'Seat offset Y',
        Editable: 'false',
        Min: {
            value: '-0.6',
            changeLimit: '0',
        },
        Max: {
            value: '0.3',
            changeLimit: '0',
        },
        Description: 'The distance from the door to the car seat.',
    },
    fSeatOffsetDistZ: {
        Label: 'Seat offset Z',
        Min: {
            value: '-0.4',
            changeLimit: '0',
        },
        Max: {
            value: '0.5',
            changeLimit: '0',
        },
        Description: 'The distance from the door to the car seat.',
    },
    nMonetaryValue: {
        Label: 'Vehicle value',
        Min: {
            value: '10000',
            changeLimit: '0',
        },
        Max: {
            value: '500000',
            changeLimit: '0',
        },
        Description: 'Vehicle worth.',
    },
    // strModelFlags: {
    //     Label: 'Model Flags',
    //     Editable: 'false',
    //     Description: 'Model flags. Written in HEX. Rightmost digit is the first one.',
    //     Min:{
    //         value: '0',
    //     },
    //     Max:{
    //         value: '999999',
    //     }
    // },
    // strHandlingFlags: {
    //     Label: 'Handling Flags',
    //     Editable: 'false',
    //     Description: 'Handling flags. Written in HEX. Rightmost digit is the first one.',
    //     Min:{
    //         value: '0',
    //     },
    //     Max:{
    //         value: '999999',
    //     }
    // },
    // strDamageFlags: {
    //     Label: 'Damage Flags',
    //     Editable: 'false',
    //     Description: 'Indicates the doors that are nonbreakable. Written in HEX. Rightmost digit is the first one.',
    //     Min:{
    //         value: '0',
    //     },
    //     Max:{
    //         value: '999999',
    //     }
    // },
    vecInertiaMultiplier: {
        Label: 'Inertial multiplier',
        Min: {
            value: '-5',
            changeLimit: '0',
        },
        Max: {
            value: '10',
            changeLimit: '0',
        }
    },
    vecCentreOfMassOffset: {
        Label: 'Centre of mass offset',
        Description: 'Defines center of mass offset. If car easily flips on turns you most likely want to change this an set offset lower.',
        Min: {
            value: '-5',
            changeLimit: '0',
        },
        Max: {
            value: '10',
            changeLimit: '0',
        }
    },
    // AIHandling: {
    //     Editable: 'false',
    //     Description:
    //         'Tells the AI which driving profile it should use when driving the vehicle. Use AVERAGE for boats, bikes, aircraft, etc.',
    // },
    // SubHandlingData: {
    //     Editable: 'false',
    //     Description: {
    //         selfClosing: 'true',
    //     },
    // },
    fWeaponDamageScaledToVehHealthMult: {
        Label: 'Weapon damage to veh health multiplier',
        Group: 'Damage',
        Min: {
            value: '0.0',
            changeLimit: '0',
        },
        Max: {
            value: '0.5',
            changeLimit: '0',
        },
    },
    fPopUpLightRotation: {
        Label: 'Pop up light rotation',
        Min: {
            value: '17.5',
            changeLimit: '0',
        },
        Max: {
            value: '45',
            changeLimit: '0',
        },
        Description: {},
    },
    fDownforceModifier: {
        Label: 'Downforce multiplier',
        Group: 'Aero',
        Min: {
            value: '1.15',
            changeLimit: '0',
        },
        Max: {
            value: '300',
            changeLimit: '0',
        },
    },
    fRocketBoostCapacity: {
        Label: 'Rocket Boost capacity',
        Group: 'Engine',
        Min: {
            value: '3',
            changeLimit: '0',
        },
        Max: {
            value: '20',
            changeLimit: '0',
        },
    },
    fBoostMaxSpeed: {
        Label: 'Boost max speed',
        Group: 'Engine',
        Min: {
            value: '15',
            changeLimit: '0',
        },
        Max: {
            value: '87.5',
            changeLimit: '0',
        },
    },
};

exports('getHandlingConfig', () => {
    return CHandlingData
})