<template>
  <div>
    <div>
      <input v-model="newUser" placeholder="担当">
      <input v-model="newTask" placeholder="Taskを追加する">
      <input v-model="newPriority" placeholder="優先度">
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
          <th v-bind:class="{done: task.is_done}">{{task.id}}</th>
          <th v-bind:class="{done: task.is_done}">{{task.user}}</th>
          <th v-bind:class="{done: task.is_done}">{{task.name}}</th>
          <th v-bind:class="{done: task.is_done}">{{task.priority}}</th>
          <th v-bind:class="{done: task.is_done}">{{task.end_date}}</th>
          <th v-bind:class="{done: task.is_done}">{{task.created_at}}</th>
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
      tasks:[],
      newTask: '',
      newUser:'',
      newPriority: ''
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
      if(this.task == '') return;
      axios.post('/api/tasks', {
        task: {name: this.newTask, user: this.newUser, priority: this.newPriority}}).then((response) => {
        this.tasks.unshift(response.data);
        this.newTask = '';
        this.newUser = '';
        this.newPriority = '';
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