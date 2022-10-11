
import { LightningElement,api } from 'lwc';

import unzipControllerApex from '@salesforce/apex/ZipFileUnpack.unpackZipAndUpload';

export default class UploadFileZipToSobjects extends LightningElement
{
    @api
    myRecordId;
    nombreArchivo;
    archivo;
    mensajeDesdeApex;
    errorMensaje;
    fileData;

    get acceptedFormats() {
        return ['.pdf', '.png'];
    }

    loadZip(event)
    {
        this.archivo = event.target.files[0];
        this.nombreArchivo = this.archivo.name;

        try
        {
            const file = event.target.files[0];
            var reader = new FileReader()
            reader.onload = () => {
                var base64 = reader.result.split(',')[1]
                this.fileData =
                {
                    'filename': file.name,
                    'base64': base64
                }
                console.log(this.fileData)
            }
            reader.readAsDataURL(file)
        }
        catch (error)
        {
            console.log(error);
        }

    }

    processZip(event)
    {
        const base64 = this.fileData.base64;
        console.log('->' + base64);
        unzipControllerApex({zipFileData : base64}).then(result=>
            {
                this.mensajeDesdeApex = result;
            })
            .catch(error =>{
                alert('No ha ido bien la cosa');
                console.log(error);
                this.errorMensaje = error;
            })
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        alert('No. of files uploaded : ' + uploadedFiles.length);
    }

}