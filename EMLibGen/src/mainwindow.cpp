/*
 Copyright (c) 2012, Visweswara R (@viswesr).
 All rights reserved.

 You may use this file under the terms of the BSD license as follows

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 1. Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_pushButtonOpenCSV_clicked()
{

    QString Symbols="", DeviceSets ="";

    QStringList csvFiles = QFileDialog::getOpenFileNames(
                this,
                "Select one or more CSV files to process",
                "",
                "CSV (*.csv *.CSV)");

    csvFiles.sort();

    foreach(QString filePath, csvFiles)
    {
        QFile csvFile(filePath);
        if (!csvFile.open(QIODevice::ReadOnly | QIODevice::Text))
            return;

        QMap<QString, QMap<QString, QMap<QString, QMap<QString, QString> > > > portBlock;
        QRegExp rx;

        QString re1 = "(/{2,2})\\s{1,}Part name;(\\w{1,})";
        QString re2 = "(/{2,2})\\s{1,}Chip name;(\\w{1,})";
        QString re3 = "(/{2,2})\\s{1,}Package;(\\w{1,})";
        QString re4 = "(/{2,2})\\s{1,}Package type;(\\w{1,})";
        QString re5 = "(/{2,2})\\s{1,}Pin count;(\\w{1,})";
        QString re6 = "(/{2,2})\\s{1,}Package dimensions;(.*)";
        QString re7 = "(\\w{1,});(P{1,1}([A-G]{1,1})(\\d{1,}));(\\w{1,});(.{1,})";
        QString re8 = "(\\w{1,});(\\w{1,});(\\w{1,});";

        QTextStream csvFileStream(&csvFile);
        QString CSVFile = csvFileStream.readAll();
        QStringList lCSVFile = CSVFile.split("\n");

        int vsspincount=1;
        for(int i=1; i < lCSVFile.count()-1; i++)
        {
            switch(i)
            {
            case 1:
                //part name
                rx.setPattern(re1);
                if(rx.indexIn(lCSVFile[i],0) == -1)
                {
                    qDebug() << "Unexpected Line / File; i = " << QString::number(i) << lCSVFile[i];
                }
                else
                {
                    QStringList reList = rx.capturedTexts();
                    portBlock["INFO"]["INFO"]["DESC"]["PART_NAME"]= reList.at(2);
                }
                break;

            case 2:
                //chip name
                rx.setPattern(re2);
                if(rx.indexIn(lCSVFile[i],0) == -1)
                {
                    qDebug() << "Unexpected Line / File; i = " << QString::number(i) << lCSVFile[i];
                }
                else
                {
                    QStringList reList = rx.capturedTexts();
                    portBlock["INFO"]["INFO"]["DESC"]["CHIP_NAME"]= reList.at(2);
                }
                break;

            case 3:
                //package
                rx.setPattern(re3);
                if(rx.indexIn(lCSVFile[i],0) == -1)
                {
                    qDebug() << "Unexpected Line / File; i = " << QString::number(i) << lCSVFile[i];
                }
                else
                {
                    QStringList reList = rx.capturedTexts();
                    portBlock["INFO"]["INFO"]["DESC"]["PACKAGE"]= reList.at(2);
                }
                break;

            case 4:
                //package type
                rx.setPattern(re4);
                if(rx.indexIn(lCSVFile[i],0) == -1)
                {
                    qDebug() << "Unexpected Line / File; i = " << QString::number(i) << lCSVFile[i];
                }
                else
                {
                    QStringList reList = rx.capturedTexts();
                    portBlock["INFO"]["INFO"]["DESC"]["PACKAGE_TYPE"]= reList.at(2);
                }
                break;

            case 5:
                //package type
                rx.setPattern(re5);
                if(rx.indexIn(lCSVFile[i],0) == -1)
                {
                    qDebug() << "Unexpected Line / File; i = " << QString::number(i) << lCSVFile[i];
                }
                else
                {
                    QStringList reList = rx.capturedTexts();
                    portBlock["INFO"]["INFO"]["DESC"]["PIN_COUNT"]= reList.at(2);
                }
                break;

            case 6:
                //package dimension
                rx.setPattern(re6);
                if(rx.indexIn(lCSVFile[i],0) == -1)
                {
                    qDebug() << "Unexpected Line / File; i = " << QString::number(i) << lCSVFile[i];
                }
                else
                {
                    QStringList reList = rx.capturedTexts();
                    portBlock["INFO"]["INFO"]["DESC"]["PACKAGE_DIMENSIONS"]= reList.at(2);
                }
                break;

            case 7:
            case 8:
            case 9:
                break;

            default:
                //package
                rx.setPattern(re7);
                if(rx.indexIn(lCSVFile[i],0) == -1) //Non I/O port
                {
                    rx.setPattern(re8);
                    if(rx.indexIn(lCSVFile[i],0) == -1)
                    {
                        qDebug() << "Unexpected Line / File; i = " << QString::number(i) << lCSVFile[i];
                    }
                    else
                    {

                        QStringList reList = rx.capturedTexts();
                        QRegExp rxsub;
                        rxsub.setPattern("(IOVDD)_(\\d{1,})");
                        if(rxsub.indexIn(reList.at(2),0) != -1)
                        {
                            portBlock["POWER_PINS"]["D_IOVDD_R"][reList.at(2)]["PIN_ID"] = reList.at(1);  //A_ B_ C_ helps in auto-ordering of power pins
                        }
                        rxsub.setPattern("(AVDD)_(\\d{1,})");
                        if(rxsub.indexIn(reList.at(2),0) != -1)
                        {
                            portBlock["POWER_PINS"]["E_AVDD_L"][reList.at(2)]["PIN_ID"] = reList.at(1);

                        }
                        rxsub.setPattern("(^AVSS)_(\\d{1,})");
                        if(rxsub.indexIn(reList.at(2),0) != -1)
                        {
                            portBlock["POWER_PINS"]["G_AVSS_L"][reList.at(2)]["PIN_ID"] = reList.at(1);

                        }
                        rxsub.setPattern("(^VSS)");
                        if(rxsub.indexIn(reList.at(2),0) != -1)
                        {
                            portBlock["POWER_PINS"]["F_VSS_R"]["VSS@" + QString::number(vsspincount)]["PIN_ID"] = reList.at(1);
                            vsspincount++;

                        }
                        rxsub.setPattern("(USB)_(\\w{1,})");
                        if(rxsub.indexIn(reList.at(2),0) != -1)
                        {
                            portBlock["POWER_PINS"]["B_USB_L"][reList.at(2)]["PIN_ID"] = reList.at(1);

                        }
                        rxsub.setPattern("(RESETn)");
                        if(rxsub.indexIn(reList.at(2),0) != -1)
                        {
                            portBlock["POWER_PINS"]["AA_OTHERS_L"][reList.at(2)]["PIN_ID"] = reList.at(1);

                        }
                        rxsub.setPattern("(DECOUPLE)");
                        if(rxsub.indexIn(reList.at(2),0) != -1)
                        {
                            portBlock["POWER_PINS"]["AB_OTHERS_R"][reList.at(2)]["PIN_ID"] = reList.at(1);

                        }
                        rxsub.setPattern("(VDD_DREG)");
                        if(rxsub.indexIn(reList.at(2),0) != -1)
                        {
                            portBlock["POWER_PINS"]["C_VDDDREG_R"][reList.at(2)]["PIN_ID"] = reList.at(1);

                        }

                    }
                }
                else //Power pins
                {
                    QStringList reList = rx.capturedTexts();

                    portBlock["IO_PINS"][reList.at(3)][reList.at(4)]["PIN_ID"]= reList.at(1);
                    portBlock["IO_PINS"][reList.at(3)][reList.at(4)]["FUNCTIONALITY"]=  reList.at(2) + " / " + reList.at(6);
                }

                break;

            }
        }

        QString Symbol="";
        QString Gate="";
        QString Connect="";
        QString DeviceSet="";

        int GateY =0;
        QString SymbolName ="";
        foreach (QString port, portBlock["IO_PINS"].keys())
        {

            QList <int> pinList;

            foreach(QString pin, portBlock["IO_PINS"][port].keys())
            {
                pinList.insert(0,pin.toInt());

            }
            qSort(pinList.begin(), pinList.end(), qLess<int>());

            SymbolName = portBlock["INFO"]["INFO"]["DESC"]["PART_NAME"] +"_"+ port ;
            Symbol+= "<symbol name=\""+SymbolName+"\">\n" ;

            QString largeststring ="";
            QFont sansFont("Helvetica", 6); //Exact type and size of font is unknown. This works for almost all cases
            QFontMetrics fm(sansFont);
            int stringlength=0;
            float y = 0;
            foreach(int pin, pinList)
            {
                y = y - 2.54;
                QString pindesc = QString(portBlock["IO_PINS"][port][QString::number(pin)]["FUNCTIONALITY"]).replace(" ","");
                QString pinpad =  QString(portBlock["IO_PINS"][port][QString::number(pin)]["PIN_ID"]).replace(" ","");


                Symbol += "<pin name=\""+ pindesc +
                        "\" x=\"0\" y=\"" +QString::number(y) +"\" length=\"middle\" />\n"; //default direction "io"

                Connect += "<connect gate=\""+port+"\" pin=\""+pindesc+"\" pad=\""+pinpad+"\"/>\n";

                //find the largest port description / functionality
                if(QString(portBlock["IO_PINS"][port][QString::number(pin)]["FUNCTIONALITY"]).length() > stringlength)
                {
                    stringlength = QString(portBlock["IO_PINS"][port][QString::number(pin)]["FUNCTIONALITY"]).length();
                    largeststring = QString(portBlock["IO_PINS"][port][QString::number(pin)]["FUNCTIONALITY"]);
                }
            }


            int textWidthInPixels = fm.width(largeststring+ "WWW"); //compensate left offset

            //qDebug()<<stringlength<<" " <<textWidthInPixels;

            //y = y - 2.54;

            QDesktopWidget *desk = QApplication::desktop();
            int XDpi = desk->physicalDpiX(); //In my pc this is 96dpi

            Symbol +="<wire x1=\""+QString::number(2.54*2)+"\" y1=\""+QString::number(0)+
                    "\" x2=\""+QString::number((textWidthInPixels * 25.4 / XDpi) )+"\" y2=\""+QString::number(0)+
                    "\" width=\"0.254\" layer=\"94\"/>\n";
            Symbol +="<wire x1=\""+QString::number(2.54*2)+"\" y1=\""+QString::number(0)+
                    "\" x2=\""+QString::number(2.54*2)+"\" y2=\""+QString::number(-2.54 * (pinList.count()+1) )+
                    "\" width=\"0.254\" layer=\"94\"/>\n";
            Symbol +="<wire x1=\""+QString::number(2.54*2)+"\" y1=\""+QString::number(-2.54 * (pinList.count()+1))+
                    "\" x2=\""+QString::number((textWidthInPixels * 25.4 / XDpi) )+"\" y2=\""+QString::number(-2.54 * (pinList.count()+1))+
                    "\" width=\"0.254\" layer=\"94\"/>\n";

            Symbol +="<wire x1=\""+QString::number((textWidthInPixels * 25.4 / XDpi) )+"\" y1=\""+QString::number(0)+
                    "\" x2=\""+QString::number((textWidthInPixels * 25.4 / XDpi) )+"\" y2=\""+QString::number(-2.54 * (pinList.count()+1))+
                    "\" width=\"0.254\" layer=\"94\"/>\n";

            Symbol +="<text x=\""+QString::number(2.54*2)+"\" y=\""+QString::number((-2.54 * (pinList.count()+1))-0.254 )+"\" size=\"1.27\" align=\"top-left\" layer=\"95\">&gt;NAME</text>\n";
            Symbol +="<text x=\""+QString::number(2.54*2)+"\" y=\""+QString::number(0+0.254 )+"\" size=\"1.27\" align=\"bottom-left\" layer=\"96\">&gt;VALUE</text>\n";

            Symbol +="</symbol>\n";

            Gate += "<gate name=\""+port+"\" symbol=\""+SymbolName+"\" x=\"0\" y=\""+QString::number(GateY)+"\"/>\n";
            GateY+= (-2.54 * (pinList.count()+1))-(2.54*3);

        }

        SymbolName = portBlock["INFO"]["INFO"]["DESC"]["PART_NAME"] +"_"+ "PWR";
        Symbol+= "<symbol name=\""+ SymbolName +"\">\n" ;

        int pincount = 0;
        float y = 0, x = 0;
        foreach (QString port, portBlock["POWER_PINS"].keys())
        {

            foreach(QString pin, portBlock["POWER_PINS"][port].keys())
            {
                y = y - 2.54;
                QString pindesc = QString(pin).replace(" ","");
                QString pinpad =  QString(portBlock["POWER_PINS"][port][pin]["PIN_ID"]).replace(" ","");

                if(port.contains(QRegExp("_R$")))
                {
                    x = 2.54 * 15;
                }
                else
                {
                    x = 0;
                }

                if(pin == QString("RESETn"))
                {
                    Symbol += "<pin name=\""+ QString(pin).replace(" ","") +
                            "\" x=\""+QString::number(x)+"\" y=\"" +QString::number(y) +"\" length=\"middle\" direction=\"pas\" function=\"dot\" ";
                }
                else
                {
                    Symbol += "<pin name=\""+ QString(pin).replace(" ","") +
                            "\" x=\""+QString::number(x)+"\" y=\"" +QString::number(y) +"\" length=\"middle\" direction=\"pwr\" ";
                }

                if(port.contains(QRegExp("_R$")))
                {
                    Symbol +=  "rot=\"R180\" />\n";
                }
                else
                {
                    Symbol +=  " />\n";
                }

                Connect += "<connect gate=\""+QString("PWR")+"\" pin=\""+pindesc+"\" pad=\""+pinpad+"\"/>\n";
                pincount++;
            }

            y = y - 2.54;
            pincount++;

        }
        Symbol +="<wire x1=\""+QString::number(2.54*2)+"\" y1=\""+QString::number(0)+
                "\" x2=\""+QString::number(2.54*13)+"\" y2=\""+QString::number(0)+
                "\" width=\"0.254\" layer=\"94\"/>\n";
        Symbol +="<wire x1=\""+QString::number(2.54*2)+"\" y1=\""+QString::number(0)+
                "\" x2=\""+QString::number(2.54*2)+"\" y2=\""+QString::number(-2.54 * (pincount+1) )+
                "\" width=\"0.254\" layer=\"94\"/>\n";
        Symbol +="<wire x1=\""+QString::number(2.54*2)+"\" y1=\""+QString::number(-2.54 * (pincount+1))+
                "\" x2=\""+QString::number(2.54*13)+"\" y2=\""+QString::number(-2.54 * (pincount+1))+
                "\" width=\"0.254\" layer=\"94\"/>\n";

        Symbol +="<wire x1=\""+QString::number(2.54*13)+"\" y1=\""+QString::number(0)+
                "\" x2=\""+QString::number(2.54*13)+"\" y2=\""+QString::number(-2.54 * (pincount+1))+
                "\" width=\"0.254\" layer=\"94\"/>\n";

        Symbol +="<text x=\""+QString::number(2.54*2)+"\" y=\""+QString::number((-2.54 * (pincount+1))-0.254 )+"\" size=\"1.27\" align=\"top-left\" layer=\"95\">&gt;NAME</text>\n";
        Symbol +="<text x=\""+QString::number(2.54*2)+"\" y=\""+QString::number(0.254)+"\" size=\"1.27\" align=\"bottom-left\" layer=\"96\">&gt;VALUE</text>\n";


        Symbol +="</symbol>\n";

        Gate += "<gate name=\""+ QString("PWR") +"\" symbol=\""+SymbolName+"\" x=\"0\" y=\""+QString::number(GateY)+"\"/>\n";
        GateY+= (-2.54 * (pincount+1))-(2.54 * 3) ;

        DeviceSet +=

                "<deviceset name=\""+portBlock["INFO"]["INFO"]["DESC"]["PART_NAME"]+"\">\n" +
                "<description>"+portBlock["INFO"]["INFO"]["DESC"]["PART_NAME"] +  " " +
                portBlock["INFO"]["INFO"]["DESC"]["CHIP_NAME"] +  " Microcontroller in " +
                portBlock["INFO"]["INFO"]["DESC"]["PACKAGE_DIMENSIONS"] + " " +
                portBlock["INFO"]["INFO"]["DESC"]["PACKAGE"] + " package" +
                "</description>\n" +
                "<gates>\n" + Gate +"</gates>\n" +
                "<devices>\n"+
                "<device name=\"" +""+"\" package=\""
                +portBlock["INFO"]["INFO"]["DESC"]["PACKAGE"]+"\">\n"+
                "<connects>\n" + Connect + "</connects>\n"+
                "</device>\n</devices>\n</deviceset>\n";

        Symbols    += Symbol;
        DeviceSets += DeviceSet;

    }

    //Read Footprint (package) file
    QFile pacFile(ui->lineEditPacPath->text());
    if (!pacFile.open(QIODevice::ReadOnly | QIODevice::Text))
        return;
    QTextStream pacStream(&pacFile);
    QString PackagesXML = pacStream.readAll();
    pacFile.close();


    //Read Eagle Library Template file
    QFile libTemplateFile(":/EnergyMicro.lbt");
    if (!libTemplateFile.open(QIODevice::ReadOnly | QIODevice::Text))
        return;

    QTextStream libTemplateStream(&libTemplateFile);
    EagleLibXML = libTemplateStream.readAll();
    libTemplateFile.close();

    EagleLibXML.replace("<!--#pAcKaGeS#-->",PackagesXML);
    EagleLibXML.replace("<!--#SyMbOls_DeViCeSeTs#-->","<symbols>\n"+Symbols+"</symbols>\n" + "<devicesets>\n" +DeviceSets+ "</devicesets>");
    ui->textEditOuput->setPlainText(EagleLibXML);

    QFile EagleOuputFile("../../output/EnergyMicro.lbr");
    EagleOuputFile.open(QIODevice::WriteOnly | QIODevice::Text);
    QTextStream EagleOuputFileStream(&EagleOuputFile);
    EagleOuputFileStream << EagleLibXML;

    // optional, as QFile destructor will already do it:
    EagleOuputFile.close();

}

void MainWindow::on_pushButtonOpenPac_clicked()
{
    QString pacFile = QFileDialog::getOpenFileName(
                this,
                "Select Foot print definition file(packages.pac)",
                "../../output",
                "Footprint (*.pac *.PAC)");
    ui->lineEditPacPath->setText(pacFile);
}



void MainWindow::on_pushButton_clicked()
{
    QString EagleLibFile = QFileDialog::getSaveFileName(
                this,
                "Eagle Library file",
                "",
                "Eagle Lib (*.lbr *.LBR)");

    QFile EagleOuputFile(EagleLibFile);
    EagleOuputFile.open(QIODevice::WriteOnly | QIODevice::Text);
    QTextStream EagleOuputFileStream(&EagleOuputFile);
    EagleOuputFileStream << EagleLibXML;

    // optional, as QFile destructor will already do it:
    EagleOuputFile.close();

}
