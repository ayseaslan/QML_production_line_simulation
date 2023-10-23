
#ifndef SYSTEMSTATE_H
#define SYSTEMSTATE_H

#include <QtCharts>
#include <QPointF>
#include <QTimer>
#include <QObject>
#include <QDebug>
#include <QString>
#include <fstream>
#include <sstream>
#include <string>
#include <iostream>
#include <random>
#include <algorithm>


class SystemState :   public QObject
{
    Q_OBJECT

        Q_PROPERTY(int xCoordinate READ xCoordinate) // worker assignment change, changes worker location 

        Q_PROPERTY(QPointF q1Value READ q1Value NOTIFY q1ValueChanged) // to read the new q1 data point in the plot 

        Q_PROPERTY(QPointF q2Value READ q2Value NOTIFY q2ValueChanged) // to read the new q2 data point in the plot 

        Q_PROPERTY(double slice1Value READ slice1Value NOTIFY slice1Changed) // idle slice in worker utilisation graph
        Q_PROPERTY(double slice2Value READ slice2Value NOTIFY slice1Changed) // machine 1 slice in worker utilisation graph
        Q_PROPERTY(double slice3Value READ slice3Value NOTIFY slice1Changed) // machine 2 slice in worker utilisation graph

        Q_PROPERTY(int getqmax READ getqmax) // to set y axis max in the queue plot 

 

public: 

    explicit SystemState(QObject* parent = nullptr) : QObject(parent), m_xCoordinate(-600), m_selectedPolicy(0), m_slice1Value(0.1), m_slice2Value(0.8), m_slice3Value(0.1), q_max(0){
        m_wTimer = new QTimer(this);
        m_wTimer->setInterval((1000 / 1)); // update the plots every second 
        connect(m_wTimer, &QTimer::timeout, this, &SystemState::wTimeout);
        m_wTimer->start();
    }

    int xCoordinate() const { return m_xCoordinate; }

    double slice1Value() const { return m_slice1Value; }
    double slice2Value() const { return m_slice2Value; }
    double slice3Value() const { return m_slice3Value; }

    int getqmax() const { return q_max; }

    QPointF q1Value() const {
        return m_q1Value;
    }

    QPointF q2Value() const {
        return m_q2Value;
    }

    int q1=0,q2=0; // the number of jobs in the buffers 
     double arr = 2;  // job arribal rate 
     double mu1 = 2.5; // m1 job process. rate
     double mu2 = 3.5; // m2 job process. rate
    int w_state = 0;// worker state : 0-idle, 1-m1, 2-m2 
    int num_jobs_finished = 0;
    int num_idle_time = 0;
    int seconds_passed = 0;
    int system_on = 1; // 1-on, 0-off 
    int num_m1 = 0; // time worker spent on machine 1
    int num_m2 = 0; // time worker spent on machine 2
    
   
    // determine the worker state based on the assignment policy selected 
    void next_w_state() {
        if (m_selectedPolicy == 0) {
            random_policy();
        }
        else if (m_selectedPolicy == 1) {
            largest_queue_policy();
        }
        else if (m_selectedPolicy == 2) {
            M1first_policy();
        }
        else if (m_selectedPolicy == 3) {
            M2first_policy();
        }
        else if (m_selectedPolicy == 4) {
            cmu_priority_policy();
        }
        else {
           
            w_state = 0; // idle state 
        }
    };

    // update the location of the worker icon in the application based on the worker state 
    void update_worker_location() {
       
        if (w_state == 0) {
            m_xCoordinate = -600;
        }
        else if (w_state == 1) {
            m_xCoordinate = -350;
        }
        else {
            m_xCoordinate = -100;
        }
        
    };

    // assignment policies are declared 
    void random_policy();
    void largest_queue_policy();
    void M1first_policy();
    void M2first_policy();
    void cmu_priority_policy();

    // to calculate perf. statistics 
    double getIdle() {

        double Value = 1.0;
        if (seconds_passed > 0) Value = num_idle_time / (double)seconds_passed;

        return Value;
    };

    double getM1time() {

        double Value = 0.0;

        if (seconds_passed > 0) Value = num_m1 / (double)seconds_passed;

        return Value;
    };

    double getM2time() {

        double Value = 0.0;

        if (seconds_passed > 0) Value = num_m2 / (double)seconds_passed;

        return Value;
    };
        

public slots: 

    // take the selected combobox index and assign the policy selected 
    Q_INVOKABLE void assignPolicy(const QString& input) {      
        m_selectedPolicy = input.toInt();
    };

    // main simulation function --sets the state for the next period 
    void next_state();

    // initializes the state if the user presses the stop button 
    void initialize();

    // restarting with the user inputs taken from the text fields 
    void restart(const QString& input1, const QString& input2, const QString& input3) {
    
        system_on = 1;
        arr= input1.toDouble();
        mu1= input2.toDouble();
        mu2= input3.toDouble();
    };
   // to write the contents in QString format in the application 
    QString getContentsQ1() {
       
        QString strValue = QString::number(q1);

        return strValue;
    };
    QString getContentsQ2() {

        QString strValue = QString::number(q2);

        return strValue;
    };

    QString getContentsM1() {

        QString strValue = "off";
        if (w_state == 1) {
            strValue = "on";
        }

        return strValue;
    };

    QString getContentsM2() {

        QString strValue = "off";
        if (w_state == 2) {
            strValue = "on";
        }
     
        return strValue;
    };

    QString getFinishedJobs() {

        QString strValue = QString::number(num_jobs_finished);

        return strValue;
    };

    QString getSeconds() {

        QString strValue = QString::number(seconds_passed);

        return strValue;
    };

    QString getContentsPerf1() {

        double throughput = 0.0;

        if(seconds_passed >0)
         throughput = num_jobs_finished / (double)seconds_passed;
        QString strValue = QString::number(throughput, 'f', 2);
             
        return strValue;
    };

    QString getContentsPerf2() {
        double idleness = 0.0;
        if (seconds_passed > 0)
        idleness = num_idle_time / (double)seconds_passed;
        QString strValue = QString::number(idleness, 'f', 2);

        return strValue;
    };

private slots:
    void wTimeout();

signals:
       
    void q1ValueChanged();
    void q2ValueChanged();
    void slice1Changed();
       
      

 private:
     int m_xCoordinate; // x coordonate of the worker 
     QTimer* m_wTimer;
     QPointF m_q1Value;   QPointF m_q2Value; // the new data points for the queue plots 
    
     int m_selectedPolicy;

     double m_slice1Value; double m_slice2Value; double m_slice3Value;

     int q_max;
};
#endif

