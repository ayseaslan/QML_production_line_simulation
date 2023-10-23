import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import QtQml.Models 2.15

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
              context.moveTo(10, 80);   // Move to the top vertex
            context.lineTo(10, 10);   // Draw a line to the bottom-left vertex
            context.lineTo(30, 10);  // Draw a line to the bottom-right vertex
               context.lineTo(30, 80);  // Draw a line to the bottom-right vertex
                     context.closePath(); 
                     context.setLineDash([5, 5])
                    context.stroke();


                                        }
                            }