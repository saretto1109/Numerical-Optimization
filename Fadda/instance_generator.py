import random
import numpy as np
from models import Operation, Job, Machine

#GENERATE AN INSTANCE FOR THE JOB SHOP PROBLEM

def generate_instance(num_jobs, num_machines,
                      proc_time_min=1, proc_time_max=99,
                      release_date_alpha=0.25,   #parameter for the release dates
                      due_date_beta_params=None, #Ex:{"scenario_name": "tight", "beta_value": 1.5}
                      weight_scheme="equal",     #"equal" o "tardiness"
                      setup_time_min=1, setup_time_max=25,
                      seed=None):
    """
    Generates an instance of the problem
    Returns: a list of Jobs, a list of Machines, the setup items (as a dictionary).
    setup_times[(id_prev_job, id_next_job, machine_id)] = setup_time
    """
    if seed is not None:           #setting a seed for the problem
        random.seed(seed)
        np.random.seed(seed)

    jobs = []
    machines = [Machine(machine_id=i+1) for i in range(num_machines)]  #machine ids --> 1, 2, 3, 4, 5, ...
    
    # 1. Genera routing e tempi di processamento per ogni commessa
    all_processing_times_sum = 0
    job_operations_details = [] # Lista temporanea per P_tot

    for j_id_actual in range(1, num_jobs + 1):
        # Routing: ogni commessa visita ogni macchina una volta in ordine casuale
        machine_sequence_for_job = random.sample(range(1, num_machines + 1), num_machines)
        
        ops_data_for_this_job = []
        current_job_total_proc_time = 0
        for op_seq_idx in range(num_machines): # Una commessa ha num_machines operazioni
            machine_id_for_op = machine_sequence_for_job[op_seq_idx]
            proc_time = random.randint(proc_time_min, proc_time_max)
            ops_data_for_this_job.append((machine_id_for_op, proc_time))
            current_job_total_proc_time += proc_time
        
        job_operations_details.append({
            "job_id": j_id_actual,
            "ops_data": ops_data_for_this_job,
            "total_proc_time": current_job_total_proc_time
        })
        all_processing_times_sum += current_job_total_proc_time

    # 2. Genera date di rilascio e date di scadenza
    max_release_time = release_date_alpha * all_processing_times_sum / num_machines if num_machines > 0 else 0

    for job_detail in job_operations_details:
        release_date = random.uniform(0, max_release_time) if max_release_time > 0 else 0
        
        # Date di scadenza (due_date_beta_params dovrebbe essere un dizionario)
        beta = 1.5 # Valore di default se non specificato
        if due_date_beta_params and "beta_value" in due_date_beta_params:
            beta = due_date_beta_params["beta_value"]
            
        due_date = release_date + beta * job_detail["total_proc_time"]
        
        # Pesi
        w_e, w_t, w_f = 1, 1, 1 # Default "equal"
        if weight_scheme == "tardiness":
            w_t = 10
            # w_e e w_f rimangono 1 come nel paper (o come preferisci definirlo)

        job_obj = Job(job_id=job_detail["job_id"],
                      operations_data=job_detail["ops_data"],
                      release_date=release_date,
                      due_date=due_date,
                      w_e=w_e, w_t=w_t, w_f=w_f)
        jobs.append(job_obj)

    # 3. Genera tempi di setup dipendenti dalla sequenza
    setup_times = {}
    job_ids_actual = [j.job_id for j in jobs]

    for m_obj in machines:
        m_id = m_obj.machine_id
        # Setup dallo stato iniziale fittizio ("j0_m") a ogni commessa reale
        for j_succ_id in job_ids_actual:
            setup_times[("j0_m", j_succ_id, m_id)] = random.randint(setup_time_min, setup_time_max)
            # Opzionale: setup per tornare allo stato fittizio (spesso 0 o non necessario)
            # setup_times[(j_succ_id, "j0_m", m_id)] = random.randint(setup_time_min, setup_time_max)


        # Setup tra tutte le coppie di commesse reali diverse
        for j_prec_id in job_ids_actual:
            for j_succ_id in job_ids_actual:
                if j_prec_id != j_succ_id:
                    setup_times[(j_prec_id, j_succ_id, m_id)] = random.randint(setup_time_min, setup_time_max)
    
    return jobs, machines, setup_times
