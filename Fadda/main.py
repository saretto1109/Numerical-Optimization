import numpy as np
import random
import copy                            
import matplotlib.pyplot as plt         
from scipy import stats                 

from models import Operation, Job, Machine     #import the problem's models


# --- 3. LOGICA DI SCHEDULAZIONE (REGOLE DI DISPATCHING) ---
# Ogni regola avrà una sua funzione. Queste funzioni generano lo schedule "ideale" (senza guasti).

def get_setup_time(prev_job_id, current_job_id, machine_id, setup_times_map):
    """Recupera il tempo di setup."""
    return setup_times_map.get((prev_job_id, current_job_id, machine_id), 0) # Default 0 se non specificato

def create_schedule_with_rule(jobs_orig, machines_orig, setup_times, rule):
    """
    Genera uno schedule iniziale (senza guasti) usando la regola specificata.
    Aggiorna gli start_time e completion_time degli oggetti Operation.
    Ritorna la lista degli oggetti Job aggiornati e degli oggetti Machine aggiornati.
    """
    jobs = copy.deepcopy(jobs_orig) # Lavora su copie per non modificare l'originale
    machines = copy.deepcopy(machines_orig)

    for m in machines: # Resetta stato macchine
        m.becomes_free_at = 0
        m.last_job_id_processed = "j0_m"
    
    for job in jobs: # Resetta stato commesse e operazioni
        job.actual_start_time_S1j = -1
        job.actual_completion_time_CIj = -1
        job.is_completed = False
        for op in job.operations:
            op.start_time = -1
            op.completion_time = -1
            op.is_completed = False
            op.is_ready_to_start = False


    # Logica di base per un simulatore a eventi discreti o time-stepping
    # Questa è la parte più complessa da implementare correttamente.
    # Dovrà gestire una lista di operazioni "pronte", la disponibilità delle macchine,
    # le precedenze interne alle commesse, e le date di rilascio.
    
    # Esempio di logica (semplificato):
    # num_total_ops = sum(len(j.operations) for j in jobs)
    # num_completed_ops = 0
    # current_time = 0
    
    # while num_completed_ops < num_total_ops:
    #     schedulable_ops_on_machines = {m.machine_id: [] for m in machines}
        
    #     for job in jobs:
    #         if job.is_completed: continue
    #         for op_idx, op in enumerate(job.operations):
    #             if op.is_completed or op.is_ready_to_start: continue # Già schedulata o in attesa di macchina
                
    #             # Verifica release date e operazione precedente
    #             prev_op_done = (op.prev_op_id_in_job is None) or \
    #                            (job.get_operation(op.prev_op_id_in_job).is_completed)
                
    #             if job.release_date <= current_time and prev_op_done:
    #                 op.is_ready_to_start = True # Pronta per essere considerata per una macchina
    #                 machine = next(m for m in machines if m.machine_id == op.machine_id)
    #                 if machine.becomes_free_at <= current_time:
    #                     schedulable_ops_on_machines[op.machine_id].append(op)
        
    #     for machine_id, ops_list in schedulable_ops_on_machines.items():
    #         if not ops_list: continue
    #         machine = next(m for m in machines if m.machine_id == machine_id)
    #         if machine.becomes_free_at > current_time: continue

    #         # Applica la regola di dispatching
    #         if rule == "EDD":
    #             ops_list.sort(key=lambda o: next(j for j in jobs if j.job_id == o.job_id).due_date)
    #         # elif rule == "SPT": ops_list.sort(key=lambda o: o.processing_time_orig)
    #         # ... altre regole
            
    #         if ops_list:
    #             op_to_schedule = ops_list[0]
    #             job_to_schedule = next(j for j in jobs if j.job_id == op_to_schedule.job_id)
                
    #             setup = get_setup_time(machine.last_job_id_processed, job_to_schedule.job_id, machine.machine_id, setup_times)
                
    #             op_to_schedule.start_time = current_time + setup # Semplificazione
    #             op_to_schedule.completion_time = op_to_schedule.start_time + op_to_schedule.processing_time_orig
                
    #             if op_to_schedule.op_id == 0: # Prima operazione della commessa
    #                 job_to_schedule.actual_start_time_S1j = op_to_schedule.start_time
                
    #             machine.becomes_free_at = op_to_schedule.completion_time
    #             machine.last_job_id_processed = job_to_schedule.job_id
    #             op_to_schedule.is_completed = True
    #             num_completed_ops += 1
                
    #             if op_to_schedule.op_id == len(job_to_schedule.operations) - 1: # Ultima operazione
    #                 job_to_schedule.actual_completion_time_CIj = op_to_schedule.completion_time
    #                 job_to_schedule.is_completed = True

    #     # Avanzamento del tempo (in un vero DES, si avanzerebbe al prossimo evento)
    #     current_time += 1 # Semplificazione, NON CORRETTO PER UN VERO SCHEDULER
    #     if current_time > 1000: # Safety break
    #         print("Warning: Max simulation time reached in ideal scheduling.")
    #         break
            
    # Dovrai implementare una logica di scheduling più robusta.
    # Questa parte è cruciale e complessa.
    print(f"TODO: Implementare la logica di scheduling per la regola {rule}")
    # Alla fine, assicurati che op.start_time e op.completion_time siano popolati per lo schedule ideale.
    # E anche job.actual_start_time_S1j e job.actual_completion_time_CIj
    
    return jobs, machines


# --- 4. SIMULAZIONE DELLO SCENARIO (CON GUASTI) ---
# Prende uno schedule iniziale e simula i guasti

def simulate_scenario_with_failures(initial_schedule_jobs, machines_orig, setup_times, failure_prob, repetition_adds_time):
    """
    Simula uno scenario con guasti partendo da uno schedule ideale (sequenza fissata).
    Ritorna il valore della funzione obiettivo per questo scenario.
    """
    scenario_jobs = copy.deepcopy(initial_schedule_jobs) # Lavora su copie
    machines = copy.deepcopy(machines_orig)

    for m in machines: # Resetta stato macchine
        m.becomes_free_at = 0
        m.last_job_id_processed = "j0_m"

    # Ordina le operazioni globalmente in base al loro start_time nello schedule iniziale
    # per simulare l'esecuzione sequenziale ma con possibili ritardi dovuti a guasti
    all_ops_in_scenario_order = []
    for job in scenario_jobs:
        for op in job.operations:
            all_ops_in_scenario_order.append(op)
    
    # È FONDAMENTALE mantenere la sequenza PER MACCHINA data dalla regola di dispatching.
    # Un modo è iterare sulle macchine e, per ogni macchina, processare le sue operazioni
    # nella sequenza determinata dallo schedule iniziale.
    
    # Questa è una logica semplificata e va raffinata.
    # Occorre creare delle code di operazioni per ogni macchina basate sullo schedule iniziale.
    # Poi processare queste code, introducendo ritardi per guasti.
    
    for job in scenario_jobs: # Resetta i tempi effettivi per questo scenario
        job.actual_start_time_S1j = -1 
        job.actual_completion_time_CIj = -1
        for op in job.operations:
            op.start_time = -1
            op.completion_time = -1
            op.actual_processing_time = op.processing_time_orig # Resetta tempo processamento
            op.failed_in_scenario = False
            op.attempts_in_scenario = 0

    # TODO: Implementare la logica di simulazione con guasti.
    # Per ogni operazione (nella sequenza data dallo schedule iniziale):
    # 1. Calcola il suo start_time tenendo conto di:
    #    - Completamento op. precedente stessa commessa (ora soggetto a guasti)
    #    - Disponibilità macchina (soggetta a guasti di op. precedenti su quella macchina)
    #    - Release date
    #    - Tempo di setup
    # 2. Simula il guasto: se random.random() < failure_prob:
    #    - op.failed_in_scenario = True
    #    - op.actual_processing_time += op.processing_time_orig (o altro tempo di ripetizione)
    # 3. Calcola il completion_time.
    # 4. Aggiorna job.actual_start_time_S1j e job.actual_completion_time_CIj.
    
    print(f"TODO: Implementare la simulazione dello scenario con guasti.")
    
    # Calcolo della funzione obiettivo per questo scenario
    # (Assumendo che job.actual_start_time_S1j e job.actual_completion_time_CIj siano stati aggiornati)
    scenario_obj_value = 0
    for job in scenario_jobs:
        if job.actual_start_time_S1j == -1 or job.actual_completion_time_CIj == -1 : continue # Non processata

        earliness = max(0, job.due_date - job.actual_completion_time_CIj)
        tardiness = max(0, job.actual_completion_time_CIj - job.due_date)
        flow_time = job.actual_completion_time_CIj - job.actual_start_time_S1j
        
        scenario_obj_value += (job.w_e * earliness + 
                               job.w_t * tardiness + 
                               job.w_f * flow_time)
                               
    return scenario_obj_value


# --- 5. CALCOLO DELLA FUNZIONE OBIETTIVO MEDIA ---
# Esegue N simulazioni di scenario e calcola la media

def estimate_average_objective(initial_schedule_jobs, machines_orig, setup_times, 
                               failure_prob, repetition_adds_time, num_scenarios):
    """
    Stima il valore medio della funzione obiettivo su num_scenarios.
    """
    objective_values_for_scenarios = []
    for _ in range(num_scenarios):
        obj_val = simulate_scenario_with_failures(
            initial_schedule_jobs, machines_orig, setup_times, 
            failure_prob, repetition_adds_time
        )
        objective_values_for_scenarios.append(obj_val)
    
    return np.mean(objective_values_for_scenarios), np.std(objective_values_for_scenarios)

# --- 6. METODI DI GENERAZIONE DI SCENARI (per Parte 3) ---
# Esempio: Latin Hypercube Sampling o altri metodi che potresti aver visto

def generate_scenarios_lhs(initial_schedule_jobs, machines_orig, setup_times, 
                           failure_prob, repetition_adds_time, num_scenarios_reduced):
    """
    Genera scenari con un metodo più avanzato (es. LHS sulla prob. di guasto o sul numero di guasti).
    Ritorna una lista di valori della funzione obiettivo.
    """
    print("TODO: Implementare un metodo di generazione scenari avanzato (es. LHS).")
    # Per ora, usiamo Monte Carlo semplice come placeholder
    obj_values = []
    for _ in range(num_scenarios_reduced):
        obj_val = simulate_scenario_with_failures(
            initial_schedule_jobs, machines_orig, setup_times, 
            failure_prob, repetition_adds_time
        )
        obj_values.append(obj_val)
    return obj_values, np.std(obj_values)


# --- 7. ESECUZIONE PRINCIPALE DELL'ASSIGNMENT ---
if __name__ == "__main__":
    # Parametri della simulazione
    FAILURE_PROB = 0.1  # Esempio: probabilità di guasto del 10% per operazione
    REPETITION_ADDS_TIME = True # Se True, un guasto aggiunge il tempo di proc. originale
    NUM_SCENARIOS_MC = 100 # Numero di scenari per la stima Monte Carlo (Parti 1 e 2)
    NUM_SCENARIOS_REDUCED = 20 # Numero di scenari per metodi avanzati (Parte 3)

    # Carica/genera dati dell'istanza
    jobs, machines, setup_times = load_or_generate_instance("istanza_esempio")
    
    print("--- PARTE 1: Regola EDD ---")
    initial_schedule_jobs_edd, _ = create_schedule_with_rule(jobs, machines, setup_times, "EDD")
    avg_obj_edd, std_obj_edd = estimate_average_objective(
        initial_schedule_jobs_edd, machines, setup_times, 
        FAILURE_PROB, REPETITION_ADDS_TIME, NUM_SCENARIOS_MC
    )
    print(f"EDD - Valore medio FO: {avg_obj_edd:.2f} (Std: {std_obj_edd:.2f})")

    # --- PARTE 2: Altre Regole di Decisione ---
    # Esempio con SPT (dovrai implementare le altre)
    # print("\n--- PARTE 2: Altre Regole ---")
    # initial_schedule_jobs_spt, _ = create_schedule_with_rule(jobs, machines, setup_times, "SPT")
    # avg_obj_spt, std_obj_spt = estimate_average_objective(
    #     initial_schedule_jobs_spt, machines, setup_times,
    #     FAILURE_PROB, REPETITION_ADDS_TIME, NUM_SCENARIOS_MC
    # )
    # print(f"SPT - Valore medio FO: {avg_obj_spt:.2f} (Std: {std_obj_spt:.2f})")
    # ... e così via per LPT, WSPT, ATCS, MSF

    # --- PARTE 3: Metodi di Generazione Scenari ---
    print("\n--- PARTE 3: Generazione Scenari Avanzata (con EDD come base) ---")
    # Qui dovresti usare un metodo come LHS o Importance Sampling.
    # Per ora, `generate_scenarios_lhs` è un placeholder che usa MC.
    # avg_obj_lhs, std_obj_lhs = generate_scenarios_lhs(
    #     initial_schedule_jobs_edd, machines, setup_times, 
    #     FAILURE_PROB, REPETITION_ADDS_TIME, NUM_SCENARIOS_REDUCED
    # )
    # print(f"EDD (LHS) - Valore medio FO: {avg_obj_lhs:.2f} (Std: {std_obj_lhs:.2f})")
    # Confronta avg_obj_lhs con avg_obj_edd e discuti.

    print("\nStruttura principale completata. Le logiche di scheduling e simulazione dettagliate sono da implementare.")