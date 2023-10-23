import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import QtQml.Models 2.15
import QtCharts 2.3
import QtQuick.Layouts

//import the c++ class backend 
import Pack 1.0 



ApplicationWindow {
    visible: true
    width: 1000
    height: 600
    title: "Serial Production Line with Two Machines and One Worker: Analysing the Performance of Service Policies"


       
SystemState{
id:state
}

            Connections {
        target: state
        onQ1ValueChanged: {
            if(lineSeries1.count > 10)
                lineSeries1.remove(0);

            lineSeries1.append(state.q1Value.x, state.q1Value.y)
            axisX.min = lineSeries1.at(0).x
            axisX.max = lineSeries1.at(lineSeries1.count-1).x
                  
            axisY.max=state.getqmax

        }
          onQ2ValueChanged: {

           if(lineSeries2.count > 10)
                lineSeries2.remove(0);

            lineSeries2.append(state.q2Value.x, state.q2Value.y)
           

          }
        onSlice1Changed:{
       pieUtil.clear()
        pieUtil.append("idle", state.slice1Value)  
           pieUtil.append("machine 1", state.slice2Value)
         pieUtil.append("machine 2", state.slice3Value) 
      
        }

        
        
    }
   

        ColumnLayout{

         spacing: 20
            anchors.fill: parent

        RowLayout {
            spacing: 20
            Layout.fillHeight: true


// policy selection 
 Rectangle {
                width: 250
                height: 100
 
            Column {
        anchors.centerIn: parent

        Text {
            text: "Select a Service Policy:"
            font.bold: true
            font.pixelSize: 12
        }

                    ComboBox {
        id: comboBox
        width: parent.width
        model: ["randomly", "the largest queue", "M1 first", "M2 first", "cmu priority policy"]
       

        onActivated: {
        var index=comboBox.currentIndex;
          state.assignPolicy(index);

       
       }



    }
    }

   

    }

            // Q1 
            Rectangle {
                width: 100
                height: 100
              
                               Canvas{
                anchors.fill:parent

                onPaint:{
                    var context = getContext("2d");
 
                // the triangle
              //  context.beginPath();
            //  context.moveTo(70, 10);   // Move to the top vertex
            //context.lineTo(10, 80);   // Draw a line to the bottom-left vertex
           // context.lineTo(80, 80);  // Draw a line to the bottom-right vertex
                //    context.closePath();  
                                    // the fill color
              //  context.fillStyle = "lightblue";
                  //  context.fill();

                     // the queue
                    context.lineWidth = 1.5;
                   
                context.beginPath();
               context.moveTo(10, 10);   // Move to the top vertex
            context.lineTo(10, 80);   // Draw a line to the bottom-left vertex
            context.lineTo(40, 80);  // Draw a line to the bottom-right vertex
               context.lineTo(40, 10);  // Draw a line to the bottom-right vertex
                     context.setLineDash([5, 5])
                    context.stroke();


                                        }

   

                            }



                Text {
                    id: q1Text
                    text: "job count Q1"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                    font.pixelSize: 12
                    color: "black"
                }

               
                
            }
            // M1 
            Rectangle {
                width: 100
                height: 100
                color: "lightgreen"
                radius: 10
                id: m1

                 Image {
        source: "machine.png" // Replace with your image file path
          anchors.horizontalCenter: parent.horizontalCenter
        width:85
        height:60
        id:m1img
    }

                Text {
                    id: m1Text
                    text: "Machine 1"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter                  
                   anchors.top: m1img.bottom
                    font.pixelSize: 12
                    color: "black"
                }

                                                    

               
            }
            // Q2 
                        Rectangle {
                width: 100
                height: 100
              
                               Canvas{
                anchors.fill:parent

                onPaint:{
                    var context = getContext("2d");
 

                     // the queue
                    context.lineWidth = 1.5;
                   
                context.beginPath();
              context.moveTo(10, 10);   // Move to the top vertex
            context.lineTo(10, 80);   // Draw a line to the bottom-left vertex
            context.lineTo(40, 80);  // Draw a line to the bottom-right vertex
               context.lineTo(40, 10);  // Draw a line to the bottom-right vertex
                     context.setLineDash([5, 5])
                    context.stroke();


                                        }
                            }



                Text {
                    id: q2Text
                    text: new Date().toLocaleTimeString()
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                    font.pixelSize: 12
                    color: "black"
                }

               
            }

              // M2 
            Rectangle {
                width: 100
                height: 100
                color: "lightgreen"
                radius: 10

                            Image {
        source: "machine.png" // Replace with your image file path
          anchors.horizontalCenter: parent.horizontalCenter
        width:85
        height:60
        id:m2img
    }

                Text {
                    id: m2Text
                    text: "Machine 2"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter                  
                   anchors.top: m2img.bottom
                    font.pixelSize: 12
                    color: "black"
                }

                Timer {
                id:simTimer
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: {  
                    
                    state.next_state();
                     var strQ1=state.getContentsQ1();
                      q1Text.text="count Q1:"+ strQ1;

                        var strQ2=state.getContentsQ2();
                      q2Text.text="count Q2:"+ strQ2;

                      var strM1=state.getContentsM1();
                     m1Text.text="state M1:"+strM1;

                      var strM2=state.getContentsM2();
                     m2Text.text="state M2:"+strM2;

                     var strP=state.getContentsPerf1();
                     var strPi=state.getContentsPerf2();
                     perfText.text="perform. TH: "+strP+ ",  IDLE: "+strPi;

                     var strF=state.getFinishedJobs();
                     finished.text="count finished: "+strF;

                    
                   
                   
                      
                      }
                }
            }

       // worker   
       Rectangle {
         width: 100
        height: 100
      

   

       Image {
        source: "product.png" // Replace with your image file path
          anchors.horizontalCenter: parent.horizontalCenter
        width:85
        height:60
        id:proimg
    }

       Text{
       text: "finished jobs"
       id:finished
                     horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter                  
                   anchors.top: proimg.bottom
                    font.pixelSize: 13
                    color: "black"
      }

             


        Image {
            source: "worker.png" // Replace with your icon path
            width: 50
            height: 50
            id: wIcon         
            x: -500
            y: 100 // Adjust the y-position as needed
        }

            Timer {
        interval: 50 // Adjust the interval as needed (milliseconds)
        running: true
        repeat: true

        onTriggered: {
            wIcon.x = state.xCoordinate; // Update the xCoordinate value
        }
    }
    }
    }

    
    RowLayout {
            spacing: 20
            Layout.fillHeight: true

                            //clock  and perf.
            Rectangle {
                width: 150
                height: 100
                 color: "lightblue"
                radius: 10

               

                   Text {
                    id: clockText
                    text: "clock"
                    anchors.horizontalCenter: parent.horizontalCenter
                   anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 12
                    color: "black"
                }

                 Text {
                    id: perfText
                    text: "Finished Jobs"
                   anchors.horizontalCenter: parent.horizontalCenter
                   anchors.verticalCenter: parent.verticalCenter-50
                    font.pixelSize: 12
                    color: "black"
                }

                

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: {  clockText.text ="Seconds passed: "+ state.getSeconds()}
                  
                }





                }
            
    // the chart box 
      Rectangle {
         width: 300
        height: 300
    

            ChartView {
        id: chartView
        width: parent.width
        height: parent.height
        anchors.fill: parent
        animationOptions: ChartView.NoAnimation
        antialiasing: true
       // backgroundColor: "#1f1f1f"

        ValueAxis {
            id: axisY
            min: 0
           // max: 5
            gridVisible: false
            //color: "#ffffff"
            //labelsColor: "#ffffff"
            //labelFormat: "%.0f"
           // tickCount: 5
        }

        ValueAxis {
            id: axisX
            min: 0
            gridVisible: false
          
        }

   LineSeries {
            id: lineSeries1
            name: "Q1"
            color: "black"
            axisX: axisX
            axisY: axisY
        }

          LineSeries {
            id: lineSeries2
            name: "Q2"
            color: "black"
            axisX: axisX
            axisY: axisY
        }


}
}



   Rectangle {
         width: 290
        height: 300
    ChartView {
        width: parent.width
        height: parent.height

         id: chartUtil
        title: "Worker Utilisation"
            anchors.fill: parent
            legend.alignment: Qt.AlignBottom
            antialiasing: true



    PieSeries {
        id: pieUtil
        PieSlice { label: "idle"; value: 10 }
        PieSlice { label: "machine 1"; value: 70 }
        PieSlice { label: "machine 2"; value: 20}
     
        
    }       
        }
    }

     // submit parameters 
  Rectangle {
         width: 200
        height: 200

        Text{
         text: "Submit Parameters and Rerun"
                   anchors.horizontalCenter: parent.horizontalCenter
                   anchors.verticalCenter: parent.verticalCenter-20
                    font.pixelSize: 12
                    color: "black"
                   
        }

            Button{
             text: "Stop and Clear"
             id: stop_button
            anchors.centerIn: parent
           
            onClicked: {
                state.initialize();
               
            }
            }

         
         // First Input
         Text{
         id:arr_t
          anchors.horizontalCenter: parent.horizontalCenter-10
           anchors.top: stop_button.bottom
           text:"arrival rate: "
         }
        TextField {
            id: input1
            width: parent.width - 50
            placeholderText: "Enter arrival rate"
            anchors.horizontalCenter: parent.horizontalCenter+10
             anchors.top: stop_button.bottom
            anchors.left: arr_t.right
             text:"2"
             
        }

           // Second Input

            Text{
         id:mu1_t
          anchors.horizontalCenter: parent.horizontalCenter-10
           anchors.top: input1.bottom
           text:"M1 service rate: "
         }

        TextField {
            id: input2
            width: parent.width - 50
            placeholderText: "Enter M1 service rate"
            anchors.horizontalCenter: parent.horizontalCenter+10
            anchors.top: input1.bottom
             anchors.left: mu1_t.right
             text:"2.5"
            
        }

         // Third Input

          Text{
         id:mu2_t
          anchors.horizontalCenter: parent.horizontalCenter-10
           anchors.top: input2.bottom
           text:"M2 service rate: "
         }

        TextField {
            id: input3
            width: parent.width - 50
            placeholderText: "Enter M2 service rate"
            anchors.horizontalCenter: parent.horizontalCenter+10
            anchors.top: input2.bottom
             anchors.left: mu2_t.right
             text:"3.5"
           
        }

         Button{
             text: "Submit and Run"
             id: start_button
             anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: input3.bottom

            onClicked: {
            var i1=input1.text;
             var i2=input2.text;
              var i3=input3.text;

                state.restart(i1,i2,i3);
               
            }
            }




            }


    }
    }
    }
    

