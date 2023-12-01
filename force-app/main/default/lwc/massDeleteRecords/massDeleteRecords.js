import { LightningElement } from 'lwc';
import lanzarBatch from '@salesforce/apex/MassDeleteRecordsBatch.processData';
import verificarEstadoDelProceso from '@salesforce/apex/MassDeleteRecordsBatch.hasBatchFinish';

export default class MassDeleteRecords extends LightningElement
{
    fileContent = '';
    estado = '';

    handleFileUpload(event)
    {
        const file = event.target.files[0];
        var reader = new FileReader();

        reader.onload = () =>
        {
            this.fileContent = reader.result;
            this.estado = 'Archivo listo, esperando a procesar';
        }

        reader.readAsText(file);
    }

    async startProcessing()
    {
        if (this.fileContent) {
            this.processing = true;
            const words = this.fileContent.split('\n');
            const batchSize = 10000;
            let startIndex = 0;


            while (startIndex < words.length)
            {
                const valueList = words.slice(startIndex, startIndex + batchSize);
                const batchId = await this.llamarBatch(valueList);
                this.estado = 'Procesando Batch con ID ' + batchId;
                while (true)
                {
                    const isFinished = await this.isBatchFinished(batchId);
                    if (isFinished)
                    {
                        this.estado = 'Finalizado, comenzando siguiente lote';
                        break;
                    }
                    // Agrega un pequeño retraso antes de verificar nuevamente
                    await this.delay(1000); // Puedes ajustar el tiempo de espera
                }
                startIndex += batchSize;
            }

            this.estado = 'Proceso finalizado por completo';
            this.processing = false;
        }
    }

    async llamarBatch(valueList) {
        return lanzarBatch({ values: valueList });
    }

    async isBatchFinished(value)
    {
        return verificarEstadoDelProceso({ batchId: value })
    }

    async delay(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

}