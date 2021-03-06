import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3

import Ubuntu.Components.ListItems 1.3 as ListItem
import QtQuick.LocalStorage 2.0

import "js/Storage.js" as Storage
import "js/Utility.js" as Utility

import "images"

/*
  Volume unit converter page
*/

Page {
     id: volumePage
     visible: false

     header: PageHeader {
        title: i18n.tr("Volume conversions")
     }

     /* define how to render the entry in the OptionSelector */
     Component {
         id: volumeUnitsListModelDelegate
         OptionSelectorDelegate { text: sourceUnit; subText: sourceUnitSymbol; }
     }

     /* ------------- Source Unit Chooser --------------- */
     Component {
         id: sourceVolumeUnitsChooserComponent

         Dialog {
             id: volumeUnitsChooserDialog
             title: i18n.tr("Found")+" "+volumeUnitsListModel.count+" "+ i18n.tr("volume units")

             OptionSelector {
                 id: volumeUnitsOptionSelector
                 expanded: true
                 multiSelection: false
                 delegate: volumeUnitsListModelDelegate
                 model: volumeUnitsListModel
                 containerHeight: itemHeight * 4
             }

             Row {
                 spacing: units.gu(2)
                 Button {
                     text: i18n.tr("Close")
                     width: units.gu(14)
                     onClicked: {
                         PopupUtils.close(volumeUnitsChooserDialog)
                     }
                 }

                 Button {
                     text: i18n.tr("Select")
                     width: units.gu(14)
                     onClicked: {
                         sourceUnitChooserButton.text = volumeUnitsListModel.get(volumeUnitsOptionSelector.selectedIndex).sourceUnit;
                         //reset previous convertions
                         convertedValue.text= ''
                         convertedValue.enabled= false
                         PopupUtils.close(volumeUnitsChooserDialog)
                     }
                 }
             }
         }
     }


     /* ------------- Destination Unit Chooser --------------- */
     Component {
         id: destinationVolumeUnitsChooserComponent

         Dialog {
             id: volumeUnitsChooserDialog
             title: i18n.tr("Found")+" "+volumeUnitsListModel.count+" "+ i18n.tr("volume units")

             OptionSelector {
                 id: volumeUnitsOptionSelector
                 expanded: true
                 multiSelection: false
                 delegate: volumeUnitsListModelDelegate
                 model: volumeUnitsListModel
                 containerHeight: itemHeight * 4
             }

             Row {
                 spacing: units.gu(2)
                 Button {
                     text: i18n.tr("Close")
                     width: units.gu(14)
                     onClicked: {
                         PopupUtils.close(volumeUnitsChooserDialog)
                     }
                 }

                 Button {
                     text: i18n.tr("Select")
                     width: units.gu(14)
                     onClicked: {
                         destinationUnitChooserButton.text = volumeUnitsListModel.get(volumeUnitsOptionSelector.selectedIndex).sourceUnit;
                         //reset previous convertions
                         convertedValue.text= ''
                         convertedValue.enabled= false
                         PopupUtils.close(volumeUnitsChooserDialog)
                     }
                 }
             }
         }
     }

     Column{
        id: volumePageColumn
        spacing: units.gu(2)
        anchors.fill: parent

        /* transparent placeholder: to place the content under the header */
        Rectangle {
            color: "transparent"
            width: parent.width
            height: units.gu(6)
        }

        Row{
            id: sourceUnitRow
            anchors.horizontalCenter: parent.horizontalCenter
            spacing:units.gu(2)

            Label{
                id: sourceUnitLabel
                anchors.verticalCenter: sourceUnitChooserButton.verticalCenter
                text: i18n.tr("From:")
            }

            TextField{
                id: valueToConvertField
                width: units.gu(20)
                enabled:true
            }

            Button{
                id: sourceUnitChooserButton
                width: units.gu(25)
                color: UbuntuColors.warmGrey
                iconName: "find"
                text: i18n.tr("Choose...")
                onClicked:  {
                    PopupUtils.open(sourceVolumeUnitsChooserComponent, sourceUnitChooserButton)
                }
            }
        }

        /* ------------------ Destination Unit row ------------------ */
        Row{
            id: destinationUnitRow
            anchors.horizontalCenter: parent.horizontalCenter
            spacing:units.gu(3)

            Label{
                id: destinationUnitLabel
                anchors.verticalCenter: destinationUnitChooserButton.verticalCenter
                text: i18n.tr("To:")
            }

            /* transparent placeholder: required to place the content under the header */
            Rectangle {
                 color: "transparent"
                 width: valueToConvertField.width
                 height: units.gu(6)
            }

            Button{
                id: destinationUnitChooserButton
                x: sourceUnitChooserButton.x
                width: units.gu(25)
                color: UbuntuColors.warmGrey
                iconName: "find"
                text: i18n.tr("Choose...")
                onClicked:  {
                    PopupUtils.open(destinationVolumeUnitsChooserComponent, destinationUnitChooserButton)
                }
            }
        }

        /* ------------ Result Row ----------- */
        Row{
            id: resultRow
            anchors.horizontalCenter: parent.horizontalCenter
            spacing:units.gu(3)

            /* transparent placeholder: required to place the content under the header */
            Rectangle {
                 color: "transparent"
                 width: destinationUnitLabel.width
                 height: units.gu(6)
            }

            TextField{
                id: convertedValue
                width: units.gu(20)
                enabled:false
            }

            Button{
                id: doConvertionButton
                width: units.gu(25)
                color: UbuntuColors.green
                text: i18n.tr("Convert")
                onClicked:  {
                    /* Perform conversion */
                    if(Utility.isInputTextEmpty(valueToConvertField.text) || Utility.isNotNumeric(valueToConvertField.text)) {
                        PopupUtils.open(invalidInputAlert);
                    } else {
                        convertedValue.text = Storage.convertVolume(sourceUnitChooserButton.text,destinationUnitChooserButton.text, valueToConvertField.text.trim());
                        convertedValue.enabled = true;
                    }
                }
            }
        }

        Row{
            id: infoRow
            anchors.horizontalCenter: parent.horizontalCenter

            Label{
                id:noteLabel
                text: i18n.tr("Note: the decimal separtor in use is '.'")
            }
        }

     }
}
