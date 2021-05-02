<template>
  <div class="mainbody">
    <div >
      <input v-model="newUser" placeholder="担当" class="childform form" >
      <input v-model="newTask" placeholder="Taskを追加する" class="childform form" >
      <select v-model="newPriority" class="childform form" >
        <option disabled value="">優先度</option>
        <option>高</option>
        <option>中</option>
        <option>低</option>
      </select>
      <datepicker v-model="newEnddate" :format="DatePickerFormat" placeholder="期日" :language="ja" class="form"></datepicker>
      <button v-on:click="createTask" class="form">追加</button>
    </div>
    <table border="1" style="border-collapse: collapse" align="center" width="70%" height="50%">
      <thead>
        <tr>
          <th>Check</th>
          <th>No.</th>
          <th>担当</th>
          <th>内容</th>
          <th>優先度</th>
          <th>期日</th>
          <th>作成日</th>
          <th>削除ボタン</th>
        </tr>
      </thead>
      <tbody v-for="(task, index) in tasks" >
          <th><input type="checkbox" v-model="task.is_done" v-on:click="update(task.id, index)"></th>
          <th v-bind:class="{done: task.is_done}">{{task.id}}</th>
          <th v-bind:class="{done: task.is_done}">{{task.user}}</th>
          <th v-bind:class="{done: task.is_done}">{{task.name}}</th>
          <th v-bind:class="{done: task.is_done}">{{task.priority}}</th>
          <th v-bind:class="{done: task.is_done}">{{task.end_date | moment}}</th>
          <th v-bind:class="{done: task.is_done}">{{task.created_at | moment}}</th>
          <th><button v-on:click="deleteTask(task.id, index)" class="delete">削除</button></th>
      </tbody>
    </table>
  </div>
  
</template>

<script>
import axios from 'axios';
import Datepicker from 'vuejs-datepicker';
import {ja} from 'vuejs-datepicker/dist/locale'
import moment from 'moment';

export default {
  data: function() {
    return {
      tasks:[],
      newTask: '',
      newUser:'',
      newPriority: '',
      newEnddate: '',
      DatePickerFormat: 'yyyy-MM-dd',
      ja:ja
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
        task: {name: this.newTask, user: this.newUser, priority: this.newPriority, end_date: this.newEnddate}}).then((response) => {
        this.tasks.unshift(response.data);
        this.newTask = '';
        this.newUser = '';
        this.newPriority = '';
        this.newEnddate ='';
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
  },
  components: {
    Datepicker
  },
  filters: {
        moment: function (date) {
            return moment(date).format('MM月DD日');
        }
    }
}
</script>