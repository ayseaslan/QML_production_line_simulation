#include "SystemState.h"

// Create a random number generator engine
std::random_device rd;
std::mt19937 generator(rd());

void SystemState::initialize() {
    q1 = 0; q2 = 0; w_state = 0; num_jobs_finished = 0; num_idle_time = 0; seconds_passed = 0; system_on = 0;
    num_m1 = 0; num_m2 = 0; 
    m_xCoordinate = -600;
    q_max = 0;
    m_q1Value.setX(0);  m_q2Value.setX(0);
}


void SystemState::next_state() {

  

    if (system_on == 1) {

       
        if (q1 > q_max) {
            q_max = q1;
        }
        if (q2 > q_max) {
            q_max = q2;
        }

        //count utils 
        if (w_state == 0) num_idle_time++;
        else if (w_state == 1) num_m1++;
        else num_m2++;


        // Create a Poisson distribution for the arrival process
        std::poisson_distribution<int> distribution_arrival(arr);

        int arrivals = distribution_arrival(generator);

        int processed_m1 = 0;
        if (w_state == 1) {
            // Create a Poisson distribution for the job processing at m1
            std::poisson_distribution<int> distribution_m1(mu1);

            processed_m1 = distribution_m1(generator);

            processed_m1 = std::min(q1, processed_m1);
        }

        int q1new = q1 + arrivals - processed_m1;

        int processed_m2 = 0;
        if (w_state == 2) {
            // Create a Poisson distribution for the job processing at m2
            std::poisson_distribution<int> distribution_m2(mu2);

            processed_m2 = distribution_m2(generator);

            processed_m2 = std::min(q2, processed_m2);
        }

        int q2new = q2 - processed_m2 + processed_m1;

        q1 = q1new;
        // qDebug() << q1;
        q2 = q2new;

        // qDebug() << q2;

        seconds_passed++;
        num_jobs_finished += processed_m2;

        next_w_state(); // run this to update the worker assignment 
     
        update_worker_location();
    }
};

void SystemState::wTimeout() {

   
    m_q1Value.setX(m_q1Value.x() + 1);
    m_q1Value.setY(q1);

    m_q2Value.setX(m_q2Value.x() + 1);
    m_q2Value.setY(q2);
   

    m_slice1Value = getIdle();
    m_slice2Value = getM1time();
    m_slice3Value= getM2time();

    emit q1ValueChanged();
    emit q2ValueChanged();
    emit slice1Changed();
    
}

void SystemState::largest_queue_policy() {
    if (q1 > 0 && q1 >= q2) {
        w_state = 1;
    }
    else if (q2 > 0 && q2 > q1) {
        w_state = 2;
    }
    else {
        w_state = 0;
    }
}

void SystemState::cmu_priority_policy() {
    if ((double)q1 / mu1 > (double)q2/mu2) {
        w_state = 1;
    }
    else if (q2+q1==0) {
        w_state = 0;
    }
    else {
        w_state = 2;
    }
}

void SystemState::random_policy() {

    std::uniform_int_distribution<int> distribution(0, 2);
    int machine = distribution(generator);
    w_state = machine;

}

void SystemState::M1first_policy() {
    if (q1 > 0) {
        w_state = 1;
    }
    else if (q1 == 0 && q2 > 0) {
        w_state = 2;
    }
    else {
        w_state = 0;
    }
}

void SystemState::M2first_policy() {
    if (q2 > 0) {
        w_state = 2;
    }
    else if (q2 == 0 && q1 > 0) {
        w_state = 1;
    }
    else {
        w_state = 0;
    }
}