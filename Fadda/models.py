#MODEL DEFINITION FOR THE JOB SHOP PROBLEM --> OPERATION, JOB, MACHINE

class Operation:
    def __init__(self, op_id, job_id, machine_id, processing_time_orig, prev_op_id_in_job=None):
        self.op_id = op_id   #unique operation id 
        self.job_id = job_id  #job to which the operation belongs
        self.machine_id = machine_id #machine in which the operation is performed
        self.processing_time_orig = processing_time_orig  #the time the operation would take to complete if there were no failures
        self.actual_processing_time = processing_time_orig #actual processing time of the operation within a specific scenario, including repetitions
        
        self.prev_op_id_in_job = prev_op_id_in_job #id of the previous operation
        
        self.start_time = -1
        self.completion_time = -1
        self.is_completed = False
        self.is_ready_to_start = False #true when the operation is ready to start
        
        self.failed_in_scenario = False   #true if it fails in the scenario 
        self.attempts_in_scenario = 0     #number of attemps

class Job:
    def __init__(self, job_id, operations_data, release_date, due_date, w_e, w_t, w_f):
        self.job_id = job_id  #unique job id
        self.operations = []  #list of the job's operations
        prev_op_id = None
        for i, op_info in enumerate(operations_data): # op_info = (machine_id, proc_time) #operations_data= [op_info1, op_info2, ...]
            op_id_in_job = i  #operation id assignment 
            op = Operation(op_id=op_id_in_job, job_id=self.job_id,                        #configuring the operation
                           machine_id=op_info[0], processing_time_orig=op_info[1],
                           prev_op_id_in_job=prev_op_id)
            self.operations.append(op)
            prev_op_id = op_id_in_job                                                     #updating the previous operation
            
        self.release_date = release_date
        self.due_date = due_date
        self.w_e = w_e    #earliness weight
        self.w_t = w_t    #tardiness weight
        self.w_f = w_f    #flow time weight
        
        #Simulation results
        self.actual_start_time_S1j = -1
        self.actual_completion_time_CIj = -1
        self.earliness = 0
        self.tardiness = 0
        self.flow_time = 0
        self.is_completed = False

    def get_operation(self, op_id_in_job):  #returns the operation identified in the job
        return self.operations[op_id_in_job] if 0 <= op_id_in_job < len(self.operations) else None

    def get_first_operation(self):         #returns the first operation of the job
        return self.operations[0] if self.operations else None
        
    def get_last_operation(self):          #returns the last operation of the job
        return self.operations[-1] if self.operations else None

class Machine:
    def __init__(self, machine_id):
        self.machine_id = machine_id
        self.becomes_free_at = 0            #records the time when the machine will become available again after the current operation
        self.last_job_id_processed = "j0_m" #dummy job for setup
