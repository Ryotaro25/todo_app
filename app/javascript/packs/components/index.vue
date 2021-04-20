<template>
  <div>
    <div>
      <input v-model="newTask" placeholder="Taskを追加する">
      <button v-on:click="createTask">追加</button>
    </div>
    <table border="1" style="border-collapse: collapse">
      <thead>
        <tr>
          <th>Check</th>
          <th>No.</th>
          <th>担当</th>
          <th>内容</th>
          <th>優先度</th>
          <th>期日</th>
          <th>作成日</th>
        </tr>
      </thead>
      <tbody v-for="(task, index) in tasks">
          <th><input type="checkbox" v-model="task.is_done" v-on:click="update(task.id, index)"></th>
          <th>{{task.id}}</th>
          <th>{{task.user}}</th>
          <th>{{task.name}}</th>
          <th>{{task.priority}}</th>
          <th>{{task.end_date}}</th>
          <th>{{task.created_at}}</th>
          <button v-on:click="deleteTask(task.id, index)">削除</button>
      </tbody>
    </table>
  </div>
  
</template>

<script>
import axios from 'axios';

export default {
  data: function() {
    return {
      tasks: [],
      newTask: ''
    }
  },
  mounted: function() {
    this.fetchTasks();
  },
  methods: {
    fetchTasks: function() {
      axios.get('api/tasks').then((response) => {
        for(let i = 0; i < response.data.tasks.length; i ++) {
          this.tasks.push(response.data.tasks[i]);
        }
      }, (error) => {
        console.log(error, response);
      });
    },
    createTask: function() {
      if(this.newTask == '') return;
      axios.post('/api/tasks', {task: {name: this.newTask}}).then((response) => {
        this.tasks.unshift(response.data);
        this.newTask = '';
      }, (error) => {
        console.log(error, response);
      });
    },
    deleteTask: function(task_id, index) {
     axios.delete('/api/tasks/' + task_id).then((response) => {
       this.tasks.splice(index, 1);
     }, (error) => {
       console.log(error, response);
     });
    },
    update: function(task_id) {
      axios.put('/api/tasks/' + task_id).then((response) => {

      }, (error) => {
        console.log(error);
      });
    }
  }
}
</script>